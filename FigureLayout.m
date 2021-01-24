classdef FigureLayout
  methods
    function fig=getFigure(obj)
      fig=AcademicFigure;
    end
    function setColor(obj,Color)
      ax=gca;
      ax.Color=Color;
    end
    function ax=Layout2(obj)
      fig=obj.getFigure();
      clf;
      gap=0.05;
      width=0.08;
      height=0.08;
      ax{1}=subtightplot(1,3,1,gap,width,height);
      LabelPlot('A')
      obj.setColor([1 1 1]*.95)
      box(ax{1},'on')
      ax{2}=subtightplot(1,3,2,gap,width,height);
      LabelPlot('B')
      obj.setColor([1 1 1]*.95)
      box(ax{2},'on')
      ax{3}=subtightplot(1,3,3,gap,width,height);
      LabelPlot('C')
      obj.setColor([1 1 1]*.95)
      box(ax{3},'on')
    end
    function ax=Layout3(obj)
      fig=obj.getFigure();
      fig.Position(3:4)=[1250 605];
      ax{1}=subplot(1,2,1);
      ax{1}.Position=[0.0587    0.1100    0.4194    0.8150];
      obj.setColor([1 1 1]*.95)
      box(ax{1})
      LabelPlot('A')
      ax{2}=subplot(3,2,2);
      ax{2}.Position=[0.5437    0.6992    0.4106    0.2327];
      box(ax{2})
      obj.setColor([1 1 1]*.95)
      ax{2}.XGrid = 'on';
      LabelPlot('B')
      ax{3}=subplot(3,2,4);
      ax{3}.Position=[0.5437    0.4017    0.4106    0.2254];
      obj.setColor([1 1 1]*.95)
      ax{3}.XGrid = 'on';
      box(ax{3})
      LabelPlot('C')
      ax{4}=subplot(3,2,6);
      box(ax{4})
      ax{4}.Position=[0.5437    0.1141    0.4106    0.2254];
      obj.setColor([1 1 1]*.95)
      ax{4}.XGrid = 'on';
      box(ax{4})
      LabelPlot('D')
    end
    function Layout4(obj)
      fig=obj.getFigure();
    end
    function Layout5(obj)
      fig=obj.getFigure();
    end
    function ax=Layout6(obj)
      fig=obj.getFigure();
      fig.Position(3:4)=[1000 600];
      ax{1}=subplot(2,3,[1,2]);
      tightLayout
      set(gca, 'YGrid', 'off', 'XGrid', 'on')
      box on
      LabelPlot('A')
      ax{2}=subplot(2,3,[4,5]);
      tightLayout
      set(gca, 'YGrid', 'off', 'XGrid', 'on')
      LabelPlot('B')
      box on
      ax{3}=subplot(2,3,3);
      tightLayout
      box on
      LabelPlot('C')
      ax{4}=subplot(2,3,6);
      tightLayout
      box on
      LabelPlot('D')
      for i=1:4
        ax{i}.Color=[1 1 1]*.95;
      end
    end
    function Layout7(obj)
      fig=obj.getFigure();
    end
    function Layout8(obj)
      fig=obj.getFigure();
    end
    function Layout9(obj)
      fig=obj.getFigure();
    end
    function ax=Layout10(obj)
      fig=obj.getFigure();
      fig.Position(3:4)=[1000 300];
      color=[1 1 1]*.95;
      ax{1}=axes('Position',[0.0559 0.1445 0.2619 0.7899],'Box','on','Color',color)
      obj.setColor(color);
      LabelPlot('A')
      ax{2}=axes('Position',[0.3807 0.1445 0.2619 0.7899],'Box','on','Color',color)
      obj.setColor(color);
      LabelPlot('B')
      ax{3}=axes('Position',[0.7047 0.6869 0.2800 0.25],'Box','on','Color',color)
      obj.setColor(color);
      set(ax{3},'xticklabel',[],'yticklabel',[])
      LabelPlot('C')
      ax{4}=axes('Position',[0.7047 0.4163 0.2800 0.2500],'Box','on','Color',color)
      obj.setColor(color);
      set(ax{4},'xticklabel',[],'yticklabel',[])
      LabelPlot('D')
      ax{5}=axes('Position',[0.7047 0.1445 0.2800 0.2500],'Box','on','Color',color)
      obj.setColor(color);
      LabelPlot('E')
    end
    function ax=Layout13(obj)
      fig=obj.getFigure();
      clf;
      fig.Position=[1170 1670 1000 300];
      ax{1}=axes('Position',[0.0950 0.68 0.52 0.24]);
      LabelPlot('A')
      ax{2}=axes('Position',[0.0950 0.11 0.52 0.52]);
      LabelPlot('B')
      ax{3}=axes('Position',[0.6916 0.11 0.25 0.81]);
      LabelPlot('C')
      for i=1:3
        axes(ax{i});
        box on
        obj.setColor([1 1 1]*.95)
      end
      ax{1}.XGrid = 'on';
      ax{2}.XGrid = 'on';
      set(ax{1},'xticklabel',[])
    end
    function ax=Layout14(obj)
      color=[1 1 1]*.95;
      fig=obj.getFigure();
      fig.Position=[1170 1670 1000 600];
      ax{1}=axes('Position',[0.0950 0.8331 0.5287 0.1184],'Box','on','Color',color,'XTickLabel',[],'XGrid','on');
      LabelPlot('A')
      ax{2}=axes('Position',[0.0950 0.5673 0.5296 0.2451],'Box','on','Color',color,'XGrid','on');
      LabelPlot('B')
      ax{3}=axes('Position',[0.6916 0.5623 0.2293 0.3915],'Box','on','Color',color,'XGrid','on');
      LabelPlot('C')
      ax{4}=axes('Position',[0.0950 0.3554 0.5287 0.1184],'Box','on','Color',color,'XTickLabel',[],'XGrid','on');
      LabelPlot('D')
      ax{5}=axes('Position',[0.0946 0.0885 0.5296 0.2451],'Box','on','Color',color,'XGrid','on');
      LabelPlot('E')
      ax{6}=axes('Position',[0.6916 0.0852 0.2293 0.3859],'Box','on','Color',color,'XGrid','on');
      LabelPlot('F')
      ax{6}.Layer = 'top';
    end
    function ax=Layout15(obj)
      color=[1 1 1]*.95;
      fig=obj.getFigure();
      fig.Position=[1170 1670 1000 300];
      ax{1}=axes('Position',[0.0950 0.7 0.5287 0.2368],'Box','on','Color',color,'XTickLabel',[],'XGrid','on');
      LabelPlot('A')
      ax{2}=axes('Position',[0.0950 0.15 0.5296 0.4902],'Box','on','Color',color,'XGrid','on');
      LabelPlot('B')
      ax{3}=axes('Position',[0.6916 0.15 0.2293 0.7830],'Box','on','Color',color,'XGrid','on');
      LabelPlot('C')
    end
  end
end