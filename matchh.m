function[d] = matchh(h1,h2)

d = sum(abs(cumsum(h1) - cumsum(h2)));
end