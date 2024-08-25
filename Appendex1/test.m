i = 1;
while i <= 10
    if i < 2
        disp(i);
    elseif i > 2
        disp(i - 1);
    end
    i = i + 1;
end

% e.g.
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize=[29.7 29.7];
fig.PaperPosition = [1 1 20 28];
fig.PaperType = 'a4' ;
fig.PaperOrientation = 'portrait' ;
print(fig,'test','-dpdf')

set(gcf,'papertype','A4');   
fig = gcf;
fig.PaperSize=[21 29.7];
fig.PaperPosition = [1 1 20 25];
print(fig,'test','-dbmp' , '-r300')