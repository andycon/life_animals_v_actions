#!/usr/bin/env python

from glob import glob
import pandas as pd
import numpy as np

features = ['framewise_displacement']
features = features + ['a_comp_cor_0{}'.format(n) for n in range(6)]
features = features + ['trans_{}'.format(n) for n in ['x','y','z']]
features = features + ['rot_{}'.format(n) for n in ['x','y','z']]

dpath='/dartfs-hpc/scratch/d29262k/data/fmriprep-like/fmriprep_1.3.2/life/fmriprep/'

subs = glob(dpath+'sub*/')

for s in subs:
    confounds = glob(s + 'func/*tsv')
    for c in confounds:
        runno = c.split('_')[4]
        conf = pd.read_csv(c,sep='\t')
        conf = conf.loc[:,features]
        nnan = sum(np.isnan(conf.to_numpy().flatten()))
        if nnan:
            w = '<><>\n\nWarning {nnan} NaNs found in counfounds for {subj} {run}!\n'
            print(w.format(nnan=nnan,subj=c.split('/')[9],run=runno))
            print(conf.head())
            conf.loc[0,['framewise_displacement']] = 0.0
            print(conf.head())

        conf.to_csv('{}/func/{}_confounds.csv'.format(s,runno), header=False)



	
