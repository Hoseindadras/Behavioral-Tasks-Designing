from psychopy import visual, core, event, data, gui, logging
import random
import math

# Experiment setup
participant_info = {'Participant': '', 'Session': ''}
dialog = gui.DlgFromDict(dictionary=participant_info, title='Risk Preference Study')
if not dialog.OK:
    core.quit()

session_number = int(participant_info['Session'])
file_name = f"data/{participant_info['Participant']}_session_{session_number}"
experiment = data.ExperimentHandler(dataFileName=file_name, extraInfo=participant_info)

# Create a window
window = visual.Window([800, 600], fullscr=False)

# Define gamble options
gamble_choices = [
    {"prob": 0.5, "reward": 20},
    {"prob": 0.3, "reward": 30},
    {"prob": 0.7, "reward": 10},
]

# Display Instructions
instruction_text = visual.TextStim(window, text="Press 'right' to gamble, 'left' to take $10. Press any key to start.")
instruction_text.draw()
window.flip()
event.waitKeys()

# Define ITI range
inter_trial_interval = (2, 6)

# Function to show instructions
def display_instructions(text):
    instruction_message = visual.TextStim(window, text=text)
    instruction_message.draw()
    window.flip()
    core.wait(4)

# Function to create pie chart
def generate_pie_chart(probability):
    scaling_factor = 0.5  # Reduce the size by half
    win_angle = probability * 360
    lose_angle = (1 - probability) * 360

    win_slice = visual.ShapeStim(
        window, vertices=[(0, 0)] + [
            (scaling_factor * math.cos(math.radians(angle)), scaling_factor * math.sin(math.radians(angle)))
            for angle in range(0, int(win_angle) + 1)
        ],
        fillColor='green', lineColor='green'
    )

    lose_slice = visual.ShapeStim(
        window, vertices=[(0, 0)] + [
            (scaling_factor * math.cos(math.radians(angle)), scaling_factor * math.sin(math.radians(angle)))
            for angle in range(int(win_angle), 361)
        ],
        fillColor='red', lineColor='red'
    )

    return win_slice, lose_slice

# Function for self trials
def perform_self_trial():
    random.shuffle(gamble_choices)
    for choice in gamble_choices:
        display_instructions("Make Your Choice")
        
        win_slice, lose_slice = generate_pie_chart(choice['prob'])
        win_slice.draw()
        lose_slice.draw()
        reward_text = visual.TextStim(window, text=f"${choice['reward']}", pos=(0, 0))
        reward_text.draw()
        window.flip()
        
        keys = event.waitKeys(maxWait=4, keyList=["left", "right"])
        selected_choice = "gamble" if keys and keys[0] == "right" else "sure"
        
        result = ""
        if selected_choice == "gamble":
            result = f"Won ${choice['reward']}" if random.random() < choice['prob'] else "Lost"
        else:
            result = "Took $10"
        
        result_text = visual.TextStim(window, text=f"Outcome: {result}")
        result_text.draw()
        window.flip()
        core.wait(1)

        iti = random.uniform(*inter_trial_interval)
        core.wait(iti)

        experiment.addData('TrialType', 'Self')
        experiment.addData('GambleProb', choice['prob'])
        experiment.addData('GambleReward', choice['reward'])
        experiment.addData('Choice', selected_choice)
        experiment.addData('Outcome', result)
        experiment.addData('ITI', iti)
        experiment.nextEntry()

# Function for observe trials
def perform_observe_trial(agent_choice, agent_result, agent_probability, agent_reward):
    display_instructions("Observe His Choice")
    
    win_slice, lose_slice = generate_pie_chart(agent_probability)
    win_slice.draw()
    lose_slice.draw()
    reward_text = visual.TextStim(window, text=f"${agent_reward}", pos=(0, 0))
    reward_text.draw()
    window.flip()
    core.wait(4)
    
    result_text = visual.TextStim(window, text=f"Agent's Outcome: {agent_result}")
    result_text.draw()
    window.flip()
    core.wait(1)
    
    iti = random.uniform(*inter_trial_interval)
    core.wait(iti)

    experiment.addData('TrialType', 'Observe')
    experiment.addData('AgentChoice', agent_choice)
    experiment.addData('AgentOutcome', agent_result)
    experiment.addData('AgentProb', agent_probability)
    experiment.addData('AgentReward', agent_reward)
    experiment.addData('ITI', iti)
    experiment.nextEntry()

# Function for predict trials
def perform_predict_trial():
    display_instructions("Predict His Choice")
    random.shuffle(gamble_choices)
    for choice in gamble_choices:
        win_slice, lose_slice = generate_pie_chart(choice['prob'])
        win_slice.draw()
        lose_slice.draw()
        reward_text = visual.TextStim(window, text=f"${choice['reward']}", pos=(0, 0))
        reward_text.draw()
        window.flip()
        
        keys = event.waitKeys(maxWait=4, keyList=["left", "right"])
        prediction = "gamble" if keys and keys[0] == "right" else "sure"
        
        experiment.addData('TrialType', 'Predict')
        experiment.addData('GambleProb', choice['prob'])
        experiment.addData('GambleReward', choice['reward'])
        experiment.addData('Prediction', prediction)
        experiment.nextEntry()
        
        iti = random.uniform(*inter_trial_interval)
        core.wait(iti)

# Function to run the session
def run_experiment_session(session_type, observee_type=None):
    if session_type in [1, 3, 5]:
        for _ in range(28):
            perform_self_trial()
    elif session_type in [2, 4]:
        for _ in range(6):
            perform_predict_trial()
        for _ in range(14):
            agent_choice = "sure" if observee_type == 'risk-averse' else "gamble"
            agent_result = "Agent Took $10" if observee_type == 'risk-averse' else "Agent Won $20"
            agent_probability = 0.3 if observee_type == 'risk-averse' else 0.7
            agent_reward = 30 if observee_type == 'risk-averse' else 20
            perform_observe_trial(agent_choice, agent_result, agent_probability, agent_reward)
        for _ in range(14):
            perform_self_trial()
        for _ in range(14):
            agent_choice = "sure" if observee_type == 'risk-averse' else "gamble"
            agent_result = "Agent Took $10" if observee_type == 'risk-averse' else "Agent Won $20"
            agent_probability = 0.3 if observee_type == 'risk-averse' else 0.7
            agent_reward = 30 if observee_type == 'risk-averse' else 20
            perform_observe_trial(agent_choice, agent_result, agent_probability, agent_reward)
        for _ in range(14):
            perform_self_trial()
        for _ in range(6):
            perform_predict_trial()

observee_preferences = ['risk-averse', 'risk-seeking']
random.shuffle(observee_preferences)

# Execute session based on input session number
if session_number in [1, 3, 5]:
    run_experiment_session(session_number)
elif session_number in [2, 4]:
    run_experiment_session(session_number, observee_preferences[session_number % 2])

# End of experiment
thank_you_message = visual.TextStim(window, text="Thank you for participating! Press any key to exit.")
thank_you_message.draw()
window.flip()
event.waitKeys()

# Save data and close the window
experiment.saveAsWideText(file_name + '.csv')
experiment.saveAsPickle(file_name)
logging.flush()
window.close()
core.quit()
