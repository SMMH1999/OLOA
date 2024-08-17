function f = RouletteWheelSelection(P)
    r = rand;
    C = cumsum(P);
    f = find(r <= C, 1, 'first');
end