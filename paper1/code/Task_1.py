from psychopy import visual, core, event, data, gui
import numpy as np
import random

# Set up experiment info
exp_info = {'Participant ID': '', 'Feedback Type': ['partial', 'complete']}
dlg = gui.DlgFromDict(dictionary=exp_info, title='Reinforcement Learning Task')
if not dlg.OK:
    core.quit()

feedback_type = exp_info['Feedback Type']

# Create a window
win = visual.Window(size=[800, 600], color='black', units='pix')

# Define the stimuli and their reward distributions
stimuli = {
    'A1': {'pos': [-200, 0], 'dist': [64, 13]},
    'B': {'pos': [200, 0], 'dist': [54, 13]},
    'A2': {'pos': [-200, 0], 'dist': [64, 13]},
    'C': {'pos': [200, 0], 'dist': [44, 13]}
}

# Function to draw stimuli
def draw_stimuli(stim_names):
    for stim_name in stim_names:
        stim = visual.Rect(win, width=100, height=100, pos=stimuli[stim_name]['pos'], fillColor='white')
        stim.draw()

# Function to show feedback
def show_feedback(chosen_stim, reward, feedback_type='partial', unchosen_stim=None, unchosen_reward=None):
    feedback_text = f"Chosen: {chosen_stim}, Reward: {reward}"
    if feedback_type == 'complete' and unchosen_stim is not None:
        feedback_text += f"\nUnchosen: {unchosen_stim}, Reward: {unchosen_reward}"
    feedback = visual.TextStim(win, text=feedback_text, color='white')
    feedback.draw()
    win.flip()
    core.wait(1)

# Function to run a trial
def run_trial(stim_pair, feedback_type='partial'):
    draw_stimuli(stim_pair)
    win.flip()
    keys = event.waitKeys(keyList=['left', 'right'])
    chosen_stim = stim_pair[0] if keys[0] == 'left' else stim_pair[1]
    unchosen_stim = stim_pair[1] if chosen_stim == stim_pair[0] else stim_pair[0]
    reward = np.random.normal(stimuli[chosen_stim]['dist'][0], stimuli[chosen_stim]['dist'][1])
    unchosen_reward = np.random.normal(stimuli[unchosen_stim]['dist'][0], stimuli[unchosen_stim]['dist'][1])
    show_feedback(chosen_stim, reward, feedback_type, unchosen_stim, unchosen_reward)

# Training Phase (20 trials)
for i in range(20):
    run_trial(['A1', 'B'], feedback_type='partial')  # Training is always partial feedback

# Learning Phase (100-300 trials)
learning_trials = data.TrialHandler(trialList=[{'pair': ['A1', 'B']}, {'pair': ['A2', 'C']}]*50, nReps=1, method='random')
for trial in learning_trials:
    run_trial(trial['pair'], feedback_type=feedback_type)

# Transfer Phase
transfer_pairs = [['A1', 'A2'], ['A1', 'B'], ['A1', 'C'], ['A2', 'B'], ['A2', 'C'], ['B', 'C']]
random.shuffle(transfer_pairs)
for pair in transfer_pairs:
    draw_stimuli(pair)
    win.flip()
    keys = event.waitKeys(keyList=['left', 'right'])
    win.flip()
    core.wait(1)  # No feedback

# Value Estimation Phase
estimation_trials = data.TrialHandler(trialList=[{'stim': stim} for stim in ['A1', 'A2', 'B', 'C']], nReps=4, method='random')
for trial in estimation_trials:
    stim = visual.Rect(win, width=100, height=100, pos=[0, 0], fillColor='white')
    stim.draw()
    win.flip()
    keys = event.waitKeys(keyList=['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])
    estimated_value = int(''.join(keys))
    win.flip()
    core.wait(1)

# Close the window
win.close()
core.quit()
