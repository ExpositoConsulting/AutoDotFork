import pickle
from tune import tune_with_playground_from_file

# Run the demo
tune_with_playground_from_file('AutoDot/mock_device_demo_config.json')

# Load the results
with open("mock_device_demo/tuning.pkl", "rb") as handle:
    data_dict = pickle.load(handle)

# Display important outputs
vols_pinchoff = data_dict['vols_pinchoff']
print("List of all observed pinch-off values and boundary points:")
print(vols_pinchoff)
