import os

from sklearn import datasets, svm
from sklearn.model_selection import train_test_split
import joblib


if __name__ == '__main__':
    # Load dataset
    iris = datasets.load_iris()
    X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.2)

    # Train a model
    clf = svm.SVC()
    clf.fit(X_train, y_train)

    model_filename = 'iris_model.joblib'
    bucket_name = 'my-ml-bucket-101'
    # Save the model
    joblib.dump(clf, model_filename)

    # Assuming you have gsutil installed and configured
    bucket_path = f'gs://{bucket_name}'
    os.system(f'gsutil cp {model_filename} {bucket_path}/{model_filename}')
