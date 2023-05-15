function final = normalizePoints(ip1)
center = mean(ip1')
variance = var(ip1',1)
final = [sqrt(2) / sqrt(variance(1) + variance(2)) 0 -center(1) * sqrt(2) / sqrt(variance(1) + variance(2)); 0 sqrt(2) / sqrt(variance(1) + variance(2)) -center(2) * sqrt(2) / sqrt(variance(1) + variance(2)); 0 0 1];