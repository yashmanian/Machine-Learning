import pandas as pandas
import quandl, math, datetime
import numpy as np
from sklearn import preprocessing, cross_validation, svm
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from matplotlib import style
import pickle

style.use('ggplot')

# DATA FRAME MANAGEMENT
df = quandl.get('WIKI/GOOGL')

# Extract useful data from frame
df = df[['Adj. Open', 'Adj. Close', 'Adj. Low', 'Adj. High', 'Adj. Volume']]

# Deltas for high-low and open-close
df['HL_PCT'] = (df['Adj. High'] - df['Adj. Low'])/df['Adj. Low'] * 100.0
df['PCT_change'] = (df['Adj. Close'] - df['Adj. Open'])/df['Adj. Open'] * 100

# Choose relevant columns
df = df[['Adj. Close','HL_PCT', 'PCT_change', 'Adj. Volume']]

forecast_col = 'Adj. Close'
df.fillna(-9999, inplace = True)

forecast_out = int(math.ceil(0.01*len(df)))

df['label'] = df[forecast_col].shift(-forecast_out)


#print df.tail

# REGRESSION SETUP
X = np.array(df.drop(['label'], 1))
X = preprocessing.scale(X)
X_lately = X[-forecast_out:]
X = X[:-forecast_out]

df.dropna(inplace = True)
y = np.array(df['label'])


X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, y, test_size = 0.2)

# clf = LinearRegression(n_jobs = -1)
# clf.fit(X_train, y_train)
# with open('linearregression.pickle','wb') as f:
# 	pickle.dump(clf,f)

pickle_in = open('linearregression.pickle','rb')
clf = pickle.load(pickle_in)

accuracy = clf.score(X_test, y_test)

forecast_set = clf.predict(X_lately)
print forecast_set, accuracy, forecast_out
df['Forecast'] = np.nan

last_date = df.iloc[-1].name
last_unix = last_date.timestamp()
one_day = 60*60*24				# Number of seconds in a day
next_unix = last_unix + one_day	# Add number of seconds for next day

for i in forecast_set:
	next_date = datetime.datetime.fromtimestamp(next_unix)
	next_unix += one_day
	df.loc[next_date] = [np.nan for _ in range(len(df.columns)-1) + [i]]

df['Adj. Close'].plot()
df['Forecast'].plot()
plt.legend(loc=4)
plt.xlabel('Date')
plt.ylabel('Price')
plt.show()
