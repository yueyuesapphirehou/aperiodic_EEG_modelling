load('E:\Research_Projects\004_Propofol\Modelling\data_fitting\data\pre.mat');
load('E:\Research_Projects\004_Propofol\Modelling\data_fitting\data\fits.mat');

ptIdx = 1;
preExample = 10.^nanmedian(rescaled.psd(:,rescaled.t<-1,ptIdx),2);
postExample = 10.^nanmedian(rescaled.psd(:,rescaled.t>0,ptIdx),2);
[oofPre,oofFun] = getFOOOF(freq(freq<50),preExample(freq<50),false);
[oofPost,oofFun] = getFOOOF(freq(freq<50),postExample(freq<50),false);
[synPre,synFun] = synDetrend(freq(freq<100),preExample(freq<100));
[synPost,synFun] = synDetrend(freq(freq<100),postExample(freq<100));

for i = 1:14
    oofFit = []; synFit = [];
    for j = 1:size(aligned.psd,2)
        oofFit(:,j) = oofFun(freq,aligned.oofPars(:,j,i));
        synFit(:,j) = synFun(freq,aligned.synPars(1:4,j,i));
    end
    aligned.syn(:,:,i) = aligned.psd(:,:,i)-synFit;
    aligned.oof(:,:,i) = aligned.psd(:,:,i)-log10(oofFit);
    aligned.pre(:,:,i) = aligned.psd(:,:,i)-log10(pre(:,i));

    oofFit = []; synFit = [];
    for j = 1:size(rescaled.psd,2)
        oofFit(:,j) = oofFun(freq,rescaled.oofPars(:,j,i));
        synFit(:,j) = synFun(freq,rescaled.synPars(1:4,j,i));
    end
    rescaled.syn(:,:,i) = rescaled.psd(:,:,i)-synFit;
    rescaled.oof(:,:,i) = rescaled.psd(:,:,i)-log10(oofFit);
    rescaled.pre(:,:,i) = rescaled.psd(:,:,i)-log10(pre(:,i));

    rescaled.oof(:,:,i) = rescaled.oof(:,:,i)-nanmedian(rescaled.oof(:,rescaled.t<-1,i),2);
    rescaled.syn(:,:,i) = rescaled.syn(:,:,i)-nanmedian(rescaled.syn(:,rescaled.t<-1,i),2);
end


deltaIdx = find(and(freq>=0.5,freq<4));
alphaIdx = find(and(freq>=8,freq<15));
betaIdx = find(and(freq>=15,freq<30));

rescaled.alpha_pre = 10*squeeze(nanmean(rescaled.pre(alphaIdx,:,:)));
rescaled.beta_pre = 10*squeeze(nanmean(rescaled.pre(betaIdx,:,:)));
rescaled.delta_pre = 10*squeeze(nanmean(rescaled.pre(deltaIdx,:,:)));

rescaled.alpha_oof = 10*squeeze(nanmean(rescaled.oof(alphaIdx,:,:)));
rescaled.beta_oof = 10*squeeze(nanmean(rescaled.oof(betaIdx,:,:)));
rescaled.delta_oof = 10*squeeze(nanmean(rescaled.oof(deltaIdx,:,:)));

rescaled.alpha_syn = 10*squeeze(nanmean(rescaled.syn(alphaIdx,:,:)));
rescaled.beta_syn = 10*squeeze(nanmean(rescaled.syn(betaIdx,:,:)));
rescaled.delta_syn = 10*squeeze(nanmean(rescaled.syn(deltaIdx,:,:)));


fig = figureNB(18.3,10.5);
subplot(3,5,1);
    plot(freq,preExample,'k','LineWidth',1);
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.5,100]);
    xticks([1,10,50]);
    xticklabels([1,10,100]);
    xlabel('Frequency (Hz)');
    ylim([1e-2,1e4]);
    yticks(10.^[-2:2:4]);
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
subplot(3,5,2);
    plot(freq,preExample,'b','LineWidth',1); hold on
    plot(freq,postExample,'k','LineWidth',1);
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.5,100]);
    xticks([1,10,100]);
    xticklabels([1,10,100]);
    xlabel('Frequency (Hz)');
    ylim([1e-2,1e4]);
    yticks(10.^[-2:2:4]);
    % ylabel(['PSD (' char(956) 'V^2/Hz)']);
subplot(3,5,3);
    plot(freq,10*log10(preExample./preExample),'k','LineWidth',1); hold on
    plot(freq,10*log10(postExample./preExample),'r','LineWidth',1);
    line(get(gca,'xlim'),[0,0],'color','b','linestyle','--');
    set(gca,'xscale','log');
    xlim([0.5,100]);
    xticks([0.5,5,50]);
    xticklabels([0.5,5,50]);
    xlabel('Frequency (Hz)');
    ylim([-10,20]);
    ylabel('Power (dB)');
subplot(3,5,4);
    imagesc(aligned.t,freq,10*nanmedian(aligned.pre,3));
    ylim([0.5,50])
    colormap('jet')
    % colorbar;
    axis xy
    xlim([-180,60]);
    ylabel('Frequency (Hz)')
    xlabel('Time to LOC (s)')
    set(gca,'CLim',[-10,18])
subplot(3,5,5)
    plotwitherror(rescaled.t,smoothdata(rescaled.alpha_pre,'movmedian',100),'SE');
    plotwitherror(rescaled.t,smoothdata(rescaled.beta_pre,'movmedian',100),'SE');
    plotwitherror(rescaled.t,smoothdata(rescaled.delta_pre,'movmedian',100),'SE');
    xlim([-1.25,0.25]);
    ylabel('Power (dB)');
    xlabel('Rescaled time')

subplot(3,5,6);
    plot(freq,oofFun(freq,oofPre),'b');  hold on
    plot(freq,preExample,'k','LineWidth',1);
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.5,100]);
    xticks([1,10,100]);
    xticklabels([1,10,100]);
    xlabel('Frequency (Hz)');
    ylim([1e-2,1e4]);
    yticks(10.^[-2:2:4]);
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
subplot(3,5,7);
    plot(freq,oofFun(freq,oofPost),'b'); hold on;
    plot(freq,postExample,'k','LineWidth',1);
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.5,100]);
    xticks([1,10,100]);
    xticklabels([1,10,100]);
    xlabel('Frequency (Hz)');
    ylim([1e-2,1e4]);
    yticks(10.^[-2:2:4]);
    % ylabel(['PSD (' char(956) 'V^2/Hz)']);
subplot(3,5,8);
    plot(freq,10*log10(preExample./oofFun(freq,oofPre)),'k','LineWidth',1); hold on
    plot(freq,10*log10(postExample./oofFun(freq,oofPost)),'r','LineWidth',1);
    set(gca,'xscale','log');
    xlim([0.5,100]);
    line(get(gca,'xlim'),[0,0],'color','b','linestyle','--');
    xticks([0.5,5,50]);
    xticklabels([0.5,5,50]);
    xlabel('Frequency (Hz)');
    ylim([-10,20]);
    ylabel('Power (dB)');
subplot(3,5,9);
    imagesc(aligned.t,freq,10*nanmedian(aligned.oof,3));
    ylim([0.5,50])
    colormap('jet')
    % colorbar;
    axis xy
    xlim([-180,60]);
    ylabel('Frequency (Hz)')
    xlabel('Time to LOC (s)')
    set(gca,'CLim',[-10,18])
    
subplot(3,5,10)
    plotwitherror(rescaled.t,smoothdata(rescaled.alpha_oof,'movmedian',100),'SE');
    plotwitherror(rescaled.t,smoothdata(rescaled.beta_oof,'movmedian',100),'SE');
    plotwitherror(rescaled.t,smoothdata(rescaled.delta_oof,'movmedian',100),'SE');
     xlim([-1.25,0.25]);
     ylabel('Power (dB)');
     xlabel('Rescaled time')

subplot(3,5,11);
    plot(freq,10.^synFun(freq,synPre),'b');  hold on
    plot(freq,preExample,'k','LineWidth',1);
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.5,100]);
    xticks([1,10,100]);
    xticklabels([1,10,100]);
    xlabel('Frequency (Hz)');
    ylim([1e-2,1e4]);
    yticks(10.^[-2:2:4]);
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
subplot(3,5,12);
    plot(freq,10.^synFun(freq,synPost),'b'); hold on;
    plot(freq,postExample,'k','LineWidth',1);
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.5,100]);
    xticks([1,10,100]);
    xticklabels([1,10,100]);
    xlabel('Frequency (Hz)');
    ylim([1e-2,1e4]);
    yticks(10.^[-2:2:4]);
    % ylabel(['PSD (' char(956) 'V^2/Hz)']);
subplot(3,5,13);
    plot(freq,10*(log10(preExample)-synFun(freq,synPre)),'k','LineWidth',1); hold on
    plot(freq,10*(log10(postExample)-synFun(freq,synPost)),'r','LineWidth',1);
    set(gca,'xscale','log');
    xlim([0.5,100]);
    line(get(gca,'xlim'),[0,0],'color','b','linestyle','--');
    xticks([0.5,5,50]);
    xticklabels([0.5,5,50]);
    xlabel('Frequency (Hz)');
    ylim([-10,20]);
    ylabel('Power (dB)');
subplot(3,5,14)
    imagesc(aligned.t,freq,10*nanmedian(aligned.syn,3));
    ylim([0.5,50])
    colormap('jet')
    % colorbar;
    axis xy
    xlim([-180,60]);
    ylabel('Frequency (Hz)')
    xlabel('Time to LOC (s)')
    set(gca,'CLim',[-10,18])
subplot(3,5,15)
    plotwitherror(rescaled.t,smoothdata(rescaled.alpha_syn,'movmedian',100),'SE');
    plotwitherror(rescaled.t,smoothdata(rescaled.beta_syn,'movmedian',100),'SE');
    plotwitherror(rescaled.t,smoothdata(rescaled.delta_syn,'movmedian',100),'SE');
    xlim([-1.25,0.25]);
    ylabel('Power (dB)');
    xlabel('Rescaled time')

gcaformat(fig);
