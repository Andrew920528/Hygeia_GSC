# Hygeia_GSC

Google Solution Challenge 2022 Project

## About
Hygeia is a two-way platform that connects elderly to their doctors. On the elderly-side, it provides easy-to-use healthcare assistance to its elderly users through many handy features. On the doctor's side, it allows the doctors to manage the elderly's medication, appointments, and status easily.
<br />
![Logo](/assets/icon/icon.png)
<image src="/assets/icon/icon.png" width="100">

## Project Motivation
Creating Healthcare technology for the elderly is a challenge. Complicated features deter them from using new technology. Also, in many societies, a lack of communication channel between the elderly and their doctors make healthcare monitoring very difficult.

## Architecture
The elderly-side app is built with Flutter. It also integrates Dialogflow for the voice command feature. HTML is used to build the doctor-side webapp. The two platforms are connected via Firebase Firestore.

## Features
The features of the app surrounds on

    1. Allow easier communication between doctor and elderly
    2. Healthcare related assistant for the elderly
### Elderly-Side
    1. Call feature
        - Emergency call
        - Contact doctor
        - Contact family members and add new people to the contact list
    2. Appointment feature
        - Set appointment via voice command
        - Set appointment via simple interface
        - Cancel and edit appointments
    3. Medication reminder feature
        - Get notified when it is time to take medication
        - View timeline to know when to take medication
        - Learn about the information about medication (how much to take, etc)
    4. Log in via phone number
    5. Interact with the assistant by voice or tapping
### Doctor-Side
    1. Log in as a doctor
    2. Create account for the patients
    3. Set/ read appointments via interface
    4. Prescribe medication schedule for the elderly
    5. Keep track of patient's status and health-care related information
## To-Do's
- [ ] \(Elderly) Full support for voice commands on current features (Call, read medication information, edit existing appointments, etc.)
- [ ] \(Elderly) More ways to interact with the assistant avatar
- [ ] \(Elderly) Confirmation button elderly can press when they have taken the medication
- [ ] \(Elderly) Remove medication once confirmed taken
- [ ] \(Elderly) Add picture for medication
- [ ] \(Doctor) Integration with existing medication record system
- [ ] \(Doctor) Visualize if patient's is following the medication schedule

