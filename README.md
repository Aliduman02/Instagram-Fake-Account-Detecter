# Instagram Fake Profile Detector

This is a Flask-based web application that utilizes a pre-trained machine learning model to predict whether an Instagram profile is fake or not. It fetches profile information using `instaloader` and then extracts relevant features to feed into the model.

## Features

* Fetches Instagram profile data (number of posts, followers, follows, privacy status, etc.).
* Extracts features from the Instagram profile for model prediction.
* Uses a pre-trained scikit-learn model (`model.pkl`) to predict the likelihood of a profile being fake.
* Provides a RESTful API endpoint to get profile information and prediction.

## Technologies Used

* **Flask**: A micro web framework for Python.
* **Instaloader**: A tool to download Instagram posts, profiles, and other metadata.
* **scikit-learn**: A machine learning library for Python (used for the pre-trained model).
* **joblib**: For saving and loading Python objects, especially scikit-learn models.

## Setup Instructions

### Prerequisites

* Python 3.x
* `pip` (Python package installer)

### Installation

1.  **Clone the repository:**

    ```bash
    git clone [https://github.com/your-username/your-repository-name.git](https://github.com/your-username/your-repository-name.git)
    cd your-repository-name
    ```

    (Replace `your-username` and `your-repository-name` with your actual GitHub details.)

2.  **Create a virtual environment (recommended):**

    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
    ```

3.  **Install the required packages:**

    ```bash
    pip install Flask instaloader scikit-learn joblib
    ```

4.  **Place your pre-trained model:**
    Ensure you have your trained machine learning model saved as `model.pkl`. By default, the application expects it at: `C:/Users/MONSTER/Desktop/sahtehesap/model.pkl`. **You will need to update this path in `app.py`** to where your `model.pkl` file is located.

    ```python
    # app.py
    model = joblib.load('path/to/your/model.pkl') # Update this line!
    ```

    For better portability, it's recommended to place `model.pkl` in the same directory as `app.py` and modify the path accordingly:

    ```python
    # app.py
    model = joblib.load('model.pkl')
    ```

5.  **Instaloader Session (Optional but Recommended for frequent use):**
    For Instaloader to fetch profile data, especially for private profiles or to avoid rate limits, it's highly recommended to log in. You can do this by running `instaloader --login YOUR_USERNAME` in your terminal. Instaloader will then store session cookies in your current directory. This Flask app will automatically use these session cookies if they are present in the same directory where `app.py` is run.

## Running the Application

1.  **Start the Flask application:**

    ```bash
    python app.py
    ```

    The application will run on `http://0.0.0.0:5000` (accessible externally if your firewall allows).

## API Endpoint

The application exposes one API endpoint:

### `GET /get_profile`

This endpoint takes an Instagram username as a query parameter and returns extracted features, the predicted fake status, and the probability of being fake.

* **URL:** `http://localhost:5000/get_profile`
* **Method:** `GET`
* **Query Parameter:**
    * `username` (string, required): The Instagram username to analyze.

* **Example Request:**

    ```
    http://localhost:5000/get_profile?username=instagram
    ```

* **Example Success Response (JSON):**

    ```json
    {
        "#followers": 673678000,
        "#follows": 200,
        "#posts": 7250,
        "description_length": 150,
        "fake_probability_percent": 5.23,
        "hasProfilePic": 1,
        "nums_length_username": 0.0,
        "prediction": 0,
        "private": 0,
        "profile_pic_url": "[https://instagram.com/p/abcdefg.jpg](https://instagram.com/p/abcdefg.jpg)"
    }
    ```

    * `prediction`: `0` indicates likely real, `1` indicates likely fake.
    * `fake_probability_percent`: The probability (in percent) that the profile is fake.

* **Example Error Response (JSON):**

    ```json
    {
        "error": "Profile 'nonexistentuser123' does not exist."
    }
    ```

## Model Training

This repository does **not** include the code for training the `model.pkl`. You are expected to provide your own pre-trained scikit-learn model that takes a list of features in the following order:

`[posts, followers, follows, private, nums_length_username, description_length, has_profile_pic]`

The model should be capable of `predict()` and `predict_proba()`.

## Contributing

Feel free to fork the repository, make improvements, and submit pull requests.

## License

[Specify your license here, e.g., MIT, Apache 2.0, etc.]
