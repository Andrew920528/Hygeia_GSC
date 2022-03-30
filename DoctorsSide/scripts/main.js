const guideList = document.querySelector('.guides');
const patientinfo = document.querySelector('#info');
const pillsinfo = document.querySelector('#pills');
const appointmentsinfo = document.querySelector('#appointments');
const loggedOutLinks = document.querySelectorAll('.logged-out');
const loggedInLinks = document.querySelectorAll('.logged-in');
const accountHtml = document.querySelector('#account-details');

const setupUI = (user) => {
    if (user) {
        accountHtml.innerHTML = user['email'];
        var docRef = "";
        db.collection(user["uid"]).doc('name').get().then(snapshot => {
            docRef = String(snapshot["_document"]["data"]["internalValue"]["root"]["value"]["internalValue"]);
            accountHtml.innerHTML = `<div style="text-align: center;"><h5>${docRef}</h5></div>` + accountHtml.innerHTML;
        });
        loggedInLinks.forEach(item => item.style.display = 'block');
        loggedOutLinks.forEach(item => item.style.display = 'none');
    } else {
        loggedInLinks.forEach(item => item.style.display = 'none');
        loggedOutLinks.forEach(item => item.style.display = 'block');
    }
}

const setupGuides = (data) => {
    if (data.length) {
        let html = '';
        data.forEach(patient => {
            const id = patient["_key"]["path"]["segments"][6];
            const docRef = db.collection("Patients").doc(id);
            docRef.get().then((doc) => {
                if (doc.exists) {
                    const guide2 = doc.data();
                    const guide = guide2["patient_info"];
                    if (guide.status == "perfect" || guide.status == "fine"){
                        const li = `
                            <li>
                                <div class="collapsible-header blue lighten-4"><b>${guide.name}</b></div>
                                <div class="collapsible-body white"><img src="img/perfect.png" style="height:20px;"/> | Age: ${guide.age} | <button style="float:right;" data-target="patient" class="btn modal-trigger" onclick=seePatient("${id}")>More Information</button></div>
                            </li>
                        `;
                        html += li;
                    } else if(guide.status == "warning" || guide.status == "critical"){
                        const li = `
                            <li>
                                <div class="collapsible-header blue lighten-4"><b>${guide.name}</b></div>
                                <div class="collapsible-body white"><img src="img/warning.png" style="height:20px;"/> | Age: ${guide.age} | <button style="float:right;" data-target="patient" class="btn modal-trigger" onclick=seePatient("${id}")>More Information</button></div>
                            </li>
                        `;
                        html += li;
                    }
                    guideList.innerHTML = html; 
                } else {
                    // doc.data() will be undefined in this case
                    console.log("No such document!");
                }
            }).catch((error) => {
                console.log("Error getting document:", error);
            });            
        }); 
    } else {
        guideList.innerHTML = `<h5 class="center-align">Login to see your patients</h5>`;
    }
}

function seePatient (patient) {
    db.collection(auth.currentUser["uid"]).get().then(snapshot => {
        var html = ``;
        var pills = ``;
        var appoiments = ``;
        data = snapshot.docs;
        data.forEach(doc => {
            if (doc.id == patient){
                const docRef = db.collection("Patients").doc(patient);
                docRef.get().then((doc) => {
                    if (doc.exists) {
                        const guide = doc.data();
                        const patient_info = guide["patient_info"];
                        const p1 = `<div style="text-align: center;"><h4>${patient_info.name}</h4></div>
                            <h5><b>Status</b>: ${patient_info.status}</h5>
                            <h5><b>Age</b>: ${patient_info.age}</h5>`;
                        html += p1;
                        var pill_html = `<div style="text-align: center;"><h4>Pills Being Taken</h4></div>`;
                        for (const pill of Object.entries(guide.medications)) {
                            const recurrance = pill[1]["recurrenceRule"];
                            const amount = pill[1]["amount"];
                            var rec = recurrance.split(";");
                            var rec_str = '';
                            for (item in rec) {
                                var rec2 = rec[item].split("=");
                                if (rec2[1] == "WEEKLY") {
                                    rec_str += "weekly";
                                } else if (rec2[1] =="DAYLY") {
                                    rec_str += "dayly";
                                } else if (rec2[1] =="MONTHLY") {
                                    rec_str += "monthly";
                                } else if (rec2[1].includes(",")) {
                                    const days = rec2[1].split(",");
                                    if ("MO" in days) {
                                        rec_str += "\non Mondays\n";
                                    } else if ("TU" in days) {
                                        rec_str += "\non Tuesdays\n";
                                    } else if ("WE" in days) {
                                        rec_str += "\non Wednesdays\n";
                                    } else if ("TH" in days) {
                                        rec_str += "\non Thursdays\n";
                                    } else if ("FR" in days) {
                                        rec_str += "\non Fridays\n";
                                    } else if ("SA" in days) {
                                        rec_str += "\non Saturdays\n";
                                    } else {
                                        rec_str += "\non Sundays";
                                    }
                                } else if (rec[item].includes("INTERVAL")) {
                                    rec2 = rec[item].split("=");
                                    rec_str = rec_str + "\nevery " + rec2[1] + " week";
                                } else if (rec[item].includes("COUNT")) {
                                    rec2 = rec[item].split("=");
                                    rec_str = rec2[1] + " times " + rec_str;
                                }
                            }
                            rec_str += (" " + amount);
                            pill_html += `<h5><b>Name: ${pill[1]["name"]}</b>
                                    <h5>Description: ${pill[1]["description"]}</h5>
                                    <h5>Taken at: ${pill[1]["startTime"]}</h5>
                                    <h5>${rec_str}</h5>`;
                        }
                        pills += pill_html;
                        var appointment_html = `<div style="text-align: center;"><h4>Appoitments</h4></div>`;
                        try {
                            for (const appointment of Object.entries(guide.appointments)) {
                                const app_inf = appointment[1]["startTime"].split(" ");
                                const date = app_inf[0].split("-");
                                const time = app_inf[1].substring(0, 5);
                                const app_inf2 = appointment[1]["endTime"].split(" ");
                                const date2 = app_inf2[0].split("-");
                                const time2 = app_inf2[1].substring(0, 5);
                            appointment_html += `<h5>From ${time} on ${date} until ${time2} on ${date2}</h5>`;
                            }
                        } catch {
                            appointment_html = ``;
                        }
                        appoiments += appointment_html;
                        appoiments += `<button data-target="patient" class="btn modal-trigger" onclick=addAppointment("${patient}")>Add Appointment</button>`;
                    }
                    pills += `<button data-target="patient" class="btn modal-trigger" onclick=addPill("${patient}")>Add Pill</button>`
                    patientinfo.innerHTML = html;
                    pillsinfo.innerHTML = pills;
                    appointmentsinfo.innerHTML = appoiments;
                });
            }
        });
    });
}

function addAppointment(id) {
    appointmentsinfo.innerHTML = `<div class="input-field" id="appoitment">
    <textarea id="app_title" class="materialize-textarea" required ></textarea>
    <label for="app_title">Title: </label>
    </div>
    <div class="input-field" id="appoitment">
    <textarea id="start_time_app" class="materialize-textarea" required ></textarea>
    <label for="start_time_app">Start (format: yy-mm-dd hh:mm:ss): </label>
    </div>
    <div class="input-field" id="appoitment">
    <textarea id="end_time_appt" class="materialize-textarea" required ></textarea>
    <label for="end_time_appt">End (format: yy-mm-dd hh:mm:ss): </label>
    </div>
    <div class="input-field" id="appoitment">
    <textarea id="locations_app" class="materialize-textarea" required ></textarea>
    <label for="locations_app">Location: </label>
    </div>
    <button data-target="patient" class="btn modal-trigger" onclick=submit("${id}")>Submit</button>`;
}

function submit(id) {
    const title = document.getElementById('app_title');
    const start = document.getElementById('start_time_app');
    const end = document.getElementById('end_time_appt');
    const location = document.getElementById('locations_app');
    var userDoc = db.collection('Patients').doc(id);
    userDoc.update({'appointments': firebase.firestore.FieldValue.arrayUnion({"endTime": end.value, "location": location.value, "startTime": start.value, "title": title.value})});
    seePatient(id);
}

function addPill(id) {
    pillsinfo.innerHTML = `<div class="input-field" id="pill">
    <textarea id="pill_name" class="materialize-textarea" required ></textarea>
    <label for="pill_name">Pill name: </label>
    </div>
    <div class="input-field" id="pill">
    <textarea id="pill_description" class="materialize-textarea" required ></textarea>
    <label for="pill_description">Pill description: </label>
    </div>
    <div class="input-field" id="pill">
    <textarea id="amount" class="materialize-textarea" required ></textarea>
    <label for="amount">Pill amount: </label>
    </div>
    <div class="input-field" id="pill">
    <textarea id="start" class="materialize-textarea" required ></textarea>
    <label for="start">Pill start time and day (format: yy-mm-dd hh:mm:ss): </label>
    </div>
    <div class="input-field" id="pill">
    <textarea id="frequency" class="materialize-textarea" required ></textarea>
    <label for="frequency">Frequency (Fromat: DAYLY, MONTHLY, WEEKLY) (in caps): </label>
    </div>
    <div class="input-field" id="pill">
    <textarea id="days" class="materialize-textarea" required ></textarea>
    <label for="days">Which days? (Format: MO,TU,WE,TH,FR,SA,SU) (in caps and separated by commas): </label>
    </div>
    <div class="input-field" id="pill">
    <label for="interval">Every how many weeks? </label>
    <textarea id="interval" class="materialize-textarea" required ></textarea>
    </div>
    <div class="input-field" id="pill">
    <label for="count">For how many weeks? </label>
    <textarea id="count" class="materialize-textarea" required ></textarea>
    </div>
    <button data-target="patient" class="btn modal-trigger" onclick=submit2("${id}")>Submit</button>`;
}

function submit2(id) {
    var pills = {};
    const docRef = db.collection("Patients").doc(id);
    const name2 = document.getElementById('pill_name');
    const amount2 = document.getElementById('amount');
    const description2 = document.getElementById('pill_description');
    // const recurrenceRule2 = document.getElementById('rec');
    // <label for="rec">Pill recurrence rule (format: FREQ=WEEKLY;BYDAY=MO,WE,FR;INTERVAL=1;COUNT=10): </label>
    var recurrance = "";
    const frequency = document.getElementById('frequency').value;
    const interval = document.getElementById('interval').value;
    const count = document.getElementById('count').value;
    const days = document.getElementById('days').value;
    var weekdays = "BYDAY=" + days;
    weekdays += ";";
    recurrance += ("FREQ=" + frequency + ";" + weekdays + "INTERVAL=" + interval + ";COUNT=" + count);
    const startTime2 = document.getElementById('start');
    pills = {"amount": amount2.value, "description": description2.value, "name": name2.value, "recurrenceRule": recurrance, "startTime": startTime2.value};
    docRef.update({'medications': firebase.firestore.FieldValue.arrayUnion(pills)});
    seePatient(id);
}

// function removePill(id, thisPill) {
//     const docRef = db.collection("Patients").doc(id);
//     docRef.update({
//         medications: firebase.firestore.FieldValue.arrayRemove(thisPill)
//     });
// }

document.addEventListener('DOMContentLoaded', function() {

    var modals = document.querySelectorAll('.modal');
    M.Modal.init(modals);

    var items = document.querySelectorAll('.collapsible');
    M.Collapsible.init(items);

});