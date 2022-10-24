import sys
import csv
import numpy as np
import scipy as sp
from scipy import optimize
import matplotlib.pyplot as plt
import math

def readdata(filename):
    with open(filename, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=' ', quotechar='|')
        fs = []
        psd = []
        for idx,row in enumerate(reader):
            temp = row[0].split(',')
            fs.append(float(temp[0]))
            psd.append(list(map(float,temp[1:])))
    psd = np.array(psd)
    fs = np.array(fs)
    return fs, psd

def read_initial(filename):
    pars00 = list()
    with open(filename, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            pars00.append(list(map(float,row)))
    return pars00

def savedata(data,filename):
    with open(filename,'w',newline='') as csvfile:
        wrt = csv.writer(csvfile, delimiter=',')
        if type(data[0]) is list:
            for ps in data:
                if(len(ps)==0):
                    wrt.writerow('0')
                else:
                   wrt.writerow(ps)
        else:
            wrt.writerow(data)

def plot_results(x_data,y_data,pars):
    mdl = full_model(x_data,pars)
    bl = biExp(scaleFrequency(x_data),pars[:4])
    fig = plt.figure()
    ax = fig.add_subplot(1,1,1)
    plt.plot(x_data,y_data)
    plt.plot(x_data,mdl)
    plt.plot(x_data,bl)
    ax.set_xscale('log')

def preparedata(x,y):
    # idcs = np.argwhere(x<150)
    # x = x[idcs]
    # y = y[idcs]
    ynew = np.log10(y)
    # ynew = ynew-ynew[0]
    return np.squeeze(x),np.squeeze(ynew)

def scaleFrequency(f):
    return (2*np.pi*f)**2

def biLorenz(fScaled, *params):
    tauI, tauE, ratio, mag = params[0]
    ys = np.zeros_like(fScaled)
    x2 = 10**ratio*np.reciprocal(1+fScaled*tauI**2) + 10**mag*np.reciprocal(1+fScaled*tauE**2)
    ys = ys + np.log10(x2)
    return ys

def biExp(fScaled, *params):
    tau1,tau2,ratio,mag = params[0]
    ys = np.zeros_like(fScaled)
    x2 = (tau1-tau2)**2 / ((1+tau1**2*fScaled)*(1+tau2**2*fScaled));
    ys = ys + mag + np.log10(np.exp(ratio)+x2);
    return ys

def gaussian_function(xs, *params):
    ys = np.zeros_like(xs)
    params = params[0]
    for ii in range(0, len(params), 3):
        ctr, hgt, wid = params[ii:ii+3]
        ys = ys + hgt * np.exp(-(xs-ctr)**2 / (2*wid**2))
    return ys

def full_model_exp2(xs,*params):
    return biExp(scaleFrequency(xs),params[0][:4]) + gaussian_function(xs,params[0][4:])

def full_model_lorenz(xs,*params):
    return biLorenz(scaleFrequency(xs),params[0][:4]) + gaussian_function(xs,params[0][4:])

def objective(params, model_func, data):
    xd, yd = data
    ym = model_func(xd,params)
    r = np.mean(np.abs(yd - ym))
    return r

def full_objective(params, model_func, data):
    xd, yd = data
    ym = model_func(xd,params)
    peaks = gaussian_function(xd,params[4:])
    # r = np.mean(np.abs(yd - ym))+np.mean(peaks[xd<20])/4+params[0]
    r = np.mean(np.abs(yd - ym))
    return r

def fit_initial(x_data,y_data,*params):
    lb_ap, ub_ap, lb_p, ub_p, model_func, startpoint = params[0]
    # Fit aperiodic component
    fScaled = scaleFrequency(x_data)
    # results1 = sp.optimize.least_squares(objective,startpoint[:4],bounds=(lb_ap,ub_ap),args = [model_func,[fScaled, y_data]],x_scale=[1e-3,1e-4,1,1],f_scale=0.5)

    lb = lb_ap + lb_p[:3]
    ub = ub_ap + ub_p[:3]
    results1 = sp.optimize.least_squares(full_objective,startpoint[:7],bounds=(lb,ub),args = [full_model_exp2,[fScaled, y_data]])
    # Fit Gaussian functions

    if len(startpoint)==4:
        return results1.x
    else:
        yDentrended = y_data-model_func(fScaled,results1.x[:4])
        yDentrended = yDentrended-min(yDentrended)
        results2 = sp.optimize.least_squares(objective,startpoint[4:],bounds=(lb_p,ub_p),args = [gaussian_function,[x_data, yDentrended]])
        return np.concatenate([results1.x[:4],results2.x])



def main(f,p,nPeaks=3,fitType='exp2',sp_ap=list()):
    # Aperiodic parameter bounds
    if(fitType=='exp2'):
        lb_ap = [7e-3,0,-20,3]
        ub_ap = [100e-3,10e-3,10,5]
        scale_ap = [5e-3,1e-3]
        full_model = full_model_exp2
        model_func = biExp
        ratio0 = -11.5
    else:
        lb_ap = [4e-3,1e-3,-3,-3]
        ub_ap = [100e-3,3e-3,1,5]
        full_model = full_model_lorenz
        model_func = biLorenz
        ratio0 = 0

    if(len(sp_ap)==0):
        sp_ap = [17e-3,1e-3,ratio0,4]

    # lb_ap.reverse()
    # ub_ap.reverse()
    # sp_ap.reverse()

    # Periodic parameter bounds
    lb_p = [0,0,0.2,6,0,0.6,15,0,1,2,0,0.4]
    ub_p = [3,4,3,15,4,4,40,3,10,5,2,2]
    sp_p = [0.5,2,1.5,11,0.3,1,22,0.1,4,4,0,1]
    lb_p = lb_p[:3*nPeaks]
    ub_p = ub_p[:3*nPeaks]
    startpoint = sp_ap + sp_p[:3*nPeaks]

    # Bounds for full model
    lb = lb_ap + lb_p
    ub = ub_ap + ub_p

    # Get initial parameter values by fitting each component seperately
    [x_data,y_data] = preparedata(f,p)

    # Use inital guess to fit all parameters simulteanously
    dIdcs = np.argwhere(x_data<10)
    aIdcs = np.argwhere((x_data>8)*(x_data<20))
    if len(y_data.shape)==1:
        # pars0 = fit_initial(x_data,y_data,[lb_ap,ub_ap,lb_p,ub_p,model_func,startpoint])
        # pars0[5] = np.max(y_data[dIdcs])-np.min(y_data[dIdcs])
        # pars0[8] = np.max(y_data[aIdcs])-np.min(y_data[aIdcs])
        # for j,par in enumerate(pars0):
        #     if(par>ub[j]):
        #         pars0[j] = ub[j]
        #     if(par<lb[j]):
        #         pars0[j] = lb[j]<0
        results1 = sp.optimize.least_squares(full_objective,startpoint,bounds=(lb,ub),args = [full_model,[x_data, y_data]])
        if(nPeaks>0):
            yDentrended = y_data-model_func(scaleFrequency(x_data),results1.x[:4])
            results2 = sp.optimize.least_squares(objective,results1.x[4:],bounds=(lb_p,ub_p),args = [gaussian_function,[x_data, yDentrended]])

            pars0 = np.concatenate((results1.x[:4],results2.x),0)
            results = sp.optimize.least_squares(full_objective,pars0,bounds=(lb,ub),args = [full_model,[x_data, y_data]])
            parsSave = results.x
        else:
            parsSave = results1.x
    else:
        pars0 = fit_initial(x_data,y_data[:,0],[lb_ap,ub_ap,lb_p,ub_p,model_func,startpoint])
        m = y_data.shape[1]
        parsSave = np.zeros([m,len(pars0)])
        for i in range(m):
            # if(nPeaks>0):
            #     pars0[5] = np.max(y_data[dIdcs,:])-np.min(y_data[dIdcs])
            #     pars0[8] = np.max(y_data[aIdcs,:])-np.min(y_data[aIdcs])
            for j,par in enumerate(pars0):
                if(par>ub[j]):
                    pars0[j] = ub[j]
                if(par<lb[j]):
                    pars0[j] = lb[j]
            results = sp.optimize.least_squares(full_objective,pars0,bounds=(lb,ub),args = [full_model,[x_data, y_data[:,i]]])
            # pars0 = results.x
            parsSave[i,:] = results.x
    return parsSave

if __name__ == "__main__":
    filename = sys.argv[1]
    fitType = sys.argv[2]
    nPeaks = int(sys.argv[3])
    startPointFile = sys.argv[4]
    f,p = readdata(filename)

    if(len(startPointFile)>0):
        with open(startPointFile, newline='') as csvfile:
            reader = csv.reader(csvfile, delimiter=',')
            startpoint = list()
            for row in reader:
                for value in row:
                    startpoint.append(float(value))
    else:
        startpoint = list()

    pars = main(f,p,nPeaks,fitType,startpoint)
    saveName = filename[:-4] + '_params.csv'
    savedata(pars.tolist(),saveName)
    print(saveName,end='')


