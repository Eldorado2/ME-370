x = linspace(-0.2,0.2,1000);

y_1 = linspace(5, 5, 1000);
y_2 = 10*cos(30*x);
y_3 = 15*cos(90*x);

y = 5 + 10*cos(30*x) + 15*cos(90*x);

hold on;

plot(x, y_1);
plot(x, y_2);
plot(x, y_3);
plot(x, y);