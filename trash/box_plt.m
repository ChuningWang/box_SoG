%% plot initial condition
% close all
% figure('visible','off')
% subplot(5,1,1:2)
% [AX,H1,H2] = plotyy(mtime,f,mtime,Spbar(mtime));
% xlim(AX(1),[0 365])
% xlim(AX(2),[0 365])
% set(H1,'color','k','linestyle','-','linewidth',1.5)
% set(H2,'color','k','linestyle','--','linewidth',1.5)
% ylabel(AX(1),'Fraser Discharge [m^3/s]','fontweight','bold','color','k')
% ylabel(AX(2),'Pacific Salinity [g/kg]','fontweight','bold','color','k')
% set(AX(1),'xtick',[])
% % axdate(12)
% set(AX,'fontweight','bold')
% subplot(5,1,3:5)
% plot(mtime,S(1,:),'color','k','linestyle','--','linewidth',1.5)
% hold on
% plot(mtime,S(2,:),'color',[.5 .5 .5],'linestyle','--','linewidth',1.5)
% plot(mtime,S(3,:),'color','k','linestyle','-','linewidth',1.5)
% plot(mtime,S(4,:),'color',[.5 .5 .5],'linestyle','-','linewidth',1.5)
% plot(mtime,S(5,:),'color','k','linestyle','-.','linewidth',1.5)
% plot(mtime,S(6,:),'color',[.5 .5 .5],'linestyle','-.','linewidth',1.5)
% xlim([0 365])
% ylim([27 35])
% set(gca,'ytick',25:1:35)
% ylabel('Salinity [g/kg]','fontweight','bold')
% xlabel('Yearday')
% % axdate(12)
% set(gca,'fontweight','bold')
% legend('S_{gu}','S_{gl}','S_{hu}','S_{hl}','S_{ju}','S_{jl}','orientation','horizontal','location','northeast')
% 
% print(gcf, '-depsc', 'box_init.eps')

%%
% % figure('visible','off')
% % orient tall
% % subplot(3,1,1)
% % plot(tt,ttl_m,'k','linewidth',1)
% % hold on
% % plot(tt,b(1)*frs_m+b(2)*eng_m+b(3),'k--','linewidth',1)
% % legend('Morrison','Regression')
% % xlim([datenum([1980 01 01 00 00 00]) datenum([2010 01 01 00 00 00])])
% % ylim([0 16000])
% % axdate
% % ylabel('River Discharge [m^3/s]')
% % 
% % subplot(3,1,2:3)
% % plot(ttl_m,b(1)*frs_m+b(2)*eng_m+b(3),'k.')
% % axis equal
% % xlabel('Morrison[m^3/s]')
% % ylabel('Regression[m^3/s]')
% % line([0 16000],[0 16000],'color','k')
% % xlim([0 16000])
% % ylim([0 16000])
% % 
% % print -depsc /home/cnwang/Dropbox/UBCThesis/BoxModel/rivercmp
% % 
% % figure
% % plot(tt,frs_m)
% % hold on
% % plot(tt,rivers.runoff(5,:)*1000^3./(repmat(m2d,1,31)*24*60*60),'r')
% % xlim([datenum([1980 01 01 00 00 00]) datenum([2010 01 01 00 00 00])])
% % axdate
% % legend('fraser@hope','fraser\_morrison')
% % print -depsc fraser_hope_marrison



