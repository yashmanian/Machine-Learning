from statistics import mean
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import style
import random

style.use('fivethirtyeight')

# xs = np.array([1, 2, 3, 4, 5, 6], dtype=np.float64)
# ys = np.array([5, 4, 6, 5, 6, 7], dtype=np.float64)

def create_dataset(hm, variance, step=2, correlation=False):
	val = 1
	ys = []
	for i in range(hm):
		y = val + random.randrange(-variance, variance)
		ys.append(y)
		if correlation and correlation == 'pos':
			val+=step
		elif correlation and correlation == 'neg':
			val = -step
		xs = [i for i in range(len(ys))]
	return np.array(xs, dtype=np.float64), np.array(ys, dtype=np.float64)


def best_fit_slope_intercept(xs, ys):
	m = (mean(xs)*mean(ys) - mean(xs*ys)) / ((mean(xs)**2) - mean(xs**2) )
	b = mean(ys) - m*mean(xs)
	return m, b


def squared_error(ys_og, ys_line):
	return sum((ys_line - ys_og)**2)


def coeff_of_det(ys_og, ys_line):
	y_mean =  [mean(ys_og) for y in ys_og]
	squared_error_reg = squared_error(ys_og, ys_line)
	squared_error_y_mean = squared_error(ys_og, y_mean)
	return 1 - (squared_error_reg / squared_error_y_mean)	

xs, ys = create_dataset(40, 10, 2, correlation='pos')
m, b = best_fit_slope_intercept(xs, ys)
regression_line = [(m*x)+b for x in xs]
predict_x = 8
predict_y = (m*predict_x) + b

r_squared = coeff_of_det(ys, regression_line)

print r_squared

plt.scatter(xs, ys)
plt.scatter(predict_x, predict_y, color = 'r', s=100)
plt.plot(xs, regression_line)
plt.show()