//get data
auth.onAuthStateChanged(user => {
    if (user) {
        db.collection(user["uid"]).get().then(snapshot => {
            if (snapshot) {
                setupGuides(snapshot.docs);
                setupUI(user);
            } else {
                let data = {
                    PatientName: "Patient's Name",
                    Status: "This describes how the patient is",
                    Age: "the age",
                    Pills: {"pill 1": ("Monday", "3:00 PM")},
                    Appointments: {"date1": "time"}
                }
                db.collection(user['uid']).doc("0").set(data)
            }
        });
       
    } else {
        setupGuides([]);
        setupUI();
    }
});

const createForm = document.querySelector('#create-form');
createForm.addEventListener('submit', (e) => {
    e.preventDefault();
    var doc_name = "";
    db.collection(auth.currentUser["uid"]).doc('name').get().then(snapshot => {
        doc_name = String(snapshot["_document"]["data"]["internalValue"]["root"]["value"]["internalValue"]);
        createPatient(doc_name);
    });
});

function createPatient(doc_name) {
    const num = document.querySelector('#number_of_pills');
    var i = 0;
    var pills = {};
    while (i < num.value) {
        const name = document.getElementById('pill_name_' + String(i + 1));
        const amount = document.getElementById('amount_' + String(i + 1));
        const description = document.getElementById('pill_description_' + String(i + 1));
        var recurrance = "";
        const frequency = document.getElementById('frequency_' + String(i + 1)).value;
        const interval = document.getElementById('interval_' + String(i + 1)).value;
        const count = document.getElementById('count_' + String(i + 1)).value;
        const days = document.getElementById('days_' + String(i + 1)).value;
        var weekdays = "BYDAY=" + days;
        weekdays += ";";
        recurrance += ("FREQ=" + frequency + ";" + weekdays + "INTERVAL=" + interval + ";COUNT=" + count);
        const startTime = document.getElementById('start_' + String(i + 1));
        pills[i] = {"amount": amount.value, "description": description.value, "name": name.value, "recurrenceRule": recurrance, "startTime": startTime.value};
        i++;
    }
    const id = Math.floor(Math.random() * 300);
    db.collection("Patients").doc(String(id)).set({
        appointments: {},
        doctor: doc_name,
        id: String(id),
        medications: pills,
        patient_info: {"age": createForm['age'].value, "name": createForm['name'].value, "status": createForm['status'].value},
    }).then(() => {
        const modal = document.querySelector('#modal-create');
        M.Modal.getInstance(modal).close();
        createForm.reset();
    });
    addPatient(id);
}

function addPatient(id) {
    db.collection(auth.currentUser["uid"]).doc(String(id)).set({
        Id: String(id),
    });
}

// signup
const signupForm = document.querySelector('#signup-form');
signupForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const email = signupForm['signup-email'].value;
    const password = signupForm['signup-password'].value;

    auth.createUserWithEmailAndPassword(email, password).then(cred => {
        const modal = document.querySelector('#modal-signup');
        M.Modal.getInstance(modal).close();
        signupForm.reset();
    });
});

const logout = document.querySelector('#logout');
logout.addEventListener('click', (e) => {
    e.preventDefault();
    auth.signOut().then(() => {
        console.log("user signed out");
    })
});

const loginform = document.querySelector('#login-form');
loginform.addEventListener('submit', (e) => {
    e.preventDefault();
    
    const email = loginform['login-email'].value;
    const password = loginform['login-password'].value;

    auth.signInWithEmailAndPassword(email, password).then(cred => {
        const modal = document.querySelector('#modal-login');
        M.Modal.getInstance(modal).close();
        loginform.reset();
    })
});
