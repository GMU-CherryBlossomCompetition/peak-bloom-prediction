import argparse
import arviz as az
import torch
import numpy as np
import pandas as pd
from patsy import dmatrix
import pyro
import pyro.distributions as dist
from pyro.infer import Predictive, NUTS, MCMC
import matplotlib.pyplot as plt


def process_data(df) -> pd.DataFrame:

    # kyoto = df[df['location'] == 'kyoto']
    # mean_20_years = kyoto.query('year > 1940 and year < 1960')['bloom_doy'].mean()
    # df.loc[-1] = [1945, 'kyoto', mean_20_years]
    # df = df.sort_values(by='year')

    year = df['year'].values
    locations = pd.Categorical(df['location']).codes
    y = df['bloom_doy'].values
    y_scaled = (y - y.mean()) / (y.std())
    t = year / year.max()
    t_unique = np.unique(t)

    knot_list = np.linspace(t_unique[0], t_unique[-1], 6)[1:-1]
    Bl = np.asarray(dmatrix(
        "bs(year, knots=knots, degree=3, include_intercept=True) - 1",
        {"year": t_unique, "knots": knot_list}
    ))

    Bl = torch.tensor(Bl, dtype=torch.float32)
    y_scaled = torch.tensor(y_scaled, dtype=torch.float32)
    locations = torch.tensor(locations, dtype=torch.long)
    data_dict = {'Bl': Bl, 'loc': locations}
    
    return data_dict, y_scaled


def multi_level_model(X, y):

    N, P = X['Bl'].size()
    locs = len(torch.unique(X['loc']))

    tau = pyro.sample('tau', dist.HalfCauchy(1))
    sigma = pyro.sample('sigma', dist.HalfNormal(1))
    beta = pyro.sample('beta', dist.Normal(0, tau).expand([P, locs]))
    mu_loc = pyro.deterministic(
        'mu_loc', torch.matmul(X['Bl'], beta)
    )

    # reshape back to X['bl'].shape[1]
    mu_loc = mu_loc.flatten()
    
    with pyro.plate('obs', mu_loc.size(0)):
       doy = pyro.sample('doy', dist.Normal(mu_loc, sigma), obs=y)
    

def main(args):
    
    data = pd.read_csv('../data/year_bloom_doy_merged.csv')
    X, y = process_data(data)

    ## Multilevel Effects Model ##
    pyro.render_model(
        multi_level_model, (X, y), 
        render_distributions=True, filename='multi_level.png'
    )

    # Prior predictive
    prior_samples = Predictive(multi_level_model, {}, num_samples=1000)(X, None)

    # Inference with NUTS
    multi_mcmc = MCMC(
        NUTS(multi_level_model), 
        num_samples=args.n_samples, warmup_steps=args.n_warmup, num_chains=4
    )
    multi_mcmc.run(X, y)

    # Sample from Posterior Predictive
    posterior_samples = multi_mcmc.get_samples(1000)
    post_pred_samples = Predictive(multi_level_model, posterior_samples)(X, None)

    # Convert to arviz inference object
    inf_multi = az.from_pyro(
        posterior=multi_mcmc,
        prior=prior_samples,
        posterior_predictive=post_pred_samples
    )
    inf_multi.to_netcdf('multi_level')


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='multi_level model using only time')
    parser.add_argument('--n_warmup', type=int, default=500)
    parser.add_argument('--n_samples', type=int, default=800)
    args = parser.parse_args()
    main(args)