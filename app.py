from flask import Flask, request, jsonify
import joblib
import instaloader

app = Flask(__name__)
model = joblib.load('C:/Users/MONSTER/Desktop/sahtehesap/model.pkl')  # model.pkl yolunu kendine göre ayarla
L = instaloader.Instaloader()

def extract_features(profile):
    posts = profile.mediacount
    followers = profile.followers
    follows = profile.followees
    username = profile.username
    private = 1 if profile.is_private else 0
    nums_length_username = sum(c.isdigit() for c in username) / len(username)
    description_length = len(profile.biography or "")
    has_profile_pic = 1 if profile.profile_pic_url else 0

    return [posts, followers, follows, private, nums_length_username, description_length, has_profile_pic]

@app.route('/get_profile', methods=['GET'])
def get_profile():
    username = request.args.get('username')
    try:
        profile = instaloader.Profile.from_username(L.context, username)
        features = extract_features(profile)

        prediction = model.predict([features])[0]
        prediction_proba = model.predict_proba([features])[0][1]  # 1 sınıfının olasılığı

        data = {
            '#posts': features[0],
            '#followers': features[1],
            '#follows': features[2],
            'private': features[3],
            'nums_length_username': features[4],
            'description_length': features[5],
            'hasProfilePic': features[6],
            'profile_pic_url': profile.profile_pic_url,
            'prediction': int(prediction),
            'fake_probability_percent': round(prediction_proba * 100, 2)
        }
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
