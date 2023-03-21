document.addEventListener('DOMContentLoaded',(event) => {
    dateInput();
    loaded();
});

let edition = 0;
const pngLvl = {Hexagon : '1', Hexagoner : '2', Hexagonest : '3'}
function loaded()
{
    document.getElementById("submit").onclick = check;
}

function pasJoueur()
{
    let table = document.getElementById("leaderboard");
    let noPlayer = document.getElementById("pasJoueur");
    let player0 = document.getElementById("player0");
    if (table.rows.length == 0)
    {
        noPlayer.innerHTML = "Pas de joueur.";
        player0.innerHTML = ` `;
    }
    else
    {
        noPlayer.innerHTML = "";
        if (player0.innerHTML != `<td> Pseudo </td> <td style="width: 20%;"> 
        LVL </td> <td> Temps </td> <td> Essais </td> <td> Date </td> <td> Actions </td>`)
        {
            player0.innerHTML = `<td> Pseudo </td> <td style="width: 20%;"> 
            LVL </td> <td> Temps </td> <td> Essais </td> <td> Date </td> <td> Actions </td>`;
        }
    }
}

function dateInput()
{
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    
    if (dd < 10) {
       dd = '0' + dd;
    }
    
    if (mm < 10) {
       mm = '0' + mm;
    } 
        
    today = yyyy + '-' + mm + '-' + dd;
    document.getElementById("dateInput").setAttribute("max", today);
}

function sort() {
    table = document.getElementById("leaderboard");
    let rowcount = 0;
    let change = 0;
    let date1;
    let date2;
    while (table.rows[rowcount + 1] != null)
    {
        if (table.rows[rowcount].cells[1].innerHTML[34] < table.rows[rowcount + 1].cells[1].innerHTML[34])
        {
            table.insertBefore(table.rows[rowcount + 1], table.rows[rowcount]);
            change = 1;
        }
        if ((table.rows[rowcount].cells[1].innerHTML == table.rows[rowcount + 1].cells[1].innerHTML) && change == 0)
        {
            date1 = new Date(table.rows[rowcount].cells[4].innerHTML);
            date2 = new Date(table.rows[rowcount + 1].cells[4].innerHTML);
            if (table.rows[rowcount].cells[2].innerHTML < table.rows[rowcount + 1].cells[2].innerHTML)
            {
                table.insertBefore(table.rows[rowcount + 1], table.rows[rowcount]);
                change = 1;
            }
            else if ((table.rows[rowcount].cells[3].innerHTML != table.rows[rowcount + 1].cells[3].innerHTML) && (table.rows[rowcount].cells[3].innerHTML > 
                table.rows[rowcount + 1].cells[3].innerHTML) && ((table.rows[rowcount].cells[2].innerHTML == table.rows[rowcount + 1].cells[2].innerHTML)))
            {
                table.insertBefore(table.rows[rowcount + 1], table.rows[rowcount]);
                change = 1;
            }
            else if ((table.rows[rowcount].cells[4].innerHTML != table.rows[rowcount + 1].cells[4].innerHTML) && (date1 > date2) && 
            (table.rows[rowcount].cells[2].innerHTML == table.rows[rowcount + 1].cells[2].innerHTML) && (table.rows[rowcount].cells[3].innerHTML == 
                table.rows[rowcount + 1].cells[3].innerHTML))
            {
                table.insertBefore(table.rows[rowcount + 1], table.rows[rowcount]);
                change = 1;
            }
        }
        rowcount++;
        if (change == 1)
        {
            rowcount = 0;
            change = 0;
        }
    }
  }

function addPlayer()
{
    let table = document.getElementById("leaderboard");
    let name = document.getElementById("nameInput");
    let lvl = document.getElementById("levelInput");
    let time = document.getElementById("timeInput");
    let death = document.getElementById("deathInput");
    let date = document.getElementById("dateInput");
    name.value = name.value.replace(/</g, "&lt;").replace(/>/g, "&gt;");
    let element = document.createElement("tr");
    table.appendChild(element);
    let img = `<img style="width: 70%;" src="lvl/${pngLvl[lvl.value]}.png" name="img">`;

    name.value.replace(/</g, "&lt;").replace(/>/g, "&gt;");
    element.innerHTML = `<td name="name"></td> <td name="lvl">${img}</td> 
    <td name="time"></td> <td name="death"></td> <td name="date"></td> 
    <td> <input type="button" name="del" value="❌"> <input type="button" name="edit" 
    value="🖍️"> </td>`;

    let nameEdit = element.querySelector("[name=name]");
    nameEdit.innerText = name.value;
    let timeEdit = element.querySelector("[name=time]");
    timeEdit.innerText = time.value;
    let deathEdit = element.querySelector("[name=death]");
    deathEdit.innerText = death.value;
    let dateEdit = element.querySelector("[name=date]");
    dateEdit.innerText = date.value;
    let imgEdit = element.querySelector("[name=img]");

    element.querySelector("[name=del]").onclick = function(){
        if ((confirm("Êtes-vous sur de vouloir supprimer ce joueur?") == true) && edition == 0)
        {
            element.remove();
            pasJoueur();
        }
        else if (edition == 1)
        {
            alert("Vous ne pouvez pas supprimer un joueur lorsqu'un autre est en édition.");
        }
    };
    title = document.getElementById("formTitle");
    element.querySelector("[name=edit]").onclick = function(){
        if (edition == 0)
        {
            title.innerHTML = `Édition du joueur ${element.querySelector("[name=name]").innerText}`;
            name.value = element.querySelector("[name=name]").innerText;
            time.value = element.querySelector("[name=time]").innerText;
            death.value = element.querySelector("[name=death]").innerText;
            date.value = element.querySelector("[name=date]").innerText;
            lvl.value = "Hexagon";
            if (element.querySelector("[name=img]").getAttribute('src') == "lvl/2.png")
            {
                lvl.value = "Hexagoner";
            }
            if (element.querySelector("[name=img]").getAttribute('src') == "lvl/3.png")
            {
                lvl.value = "Hexagonest";
            }
            edition = 1;
            let button = document.getElementById("buttonForm");
            alert("Utiliser le formulaire d'ajout de joueur pour éditer le joueur.");
            button.innerHTML = `<input type="button" id="confEdit" value="Éditer"> 
            <input type="button" id="noEdit" value="Annuler">`;
            document.getElementById("noEdit").onclick = function(){
                if (confirm("Annuler l'édition?") == true)
                {
                    edition = 0;
                    title.innerHTML = "Ajouter un joueur";
                    button.innerHTML = `<input type="button" id="submit" value="Confirmer">`;
                    document.getElementById("form").reset();
                    document.getElementById("submit").onclick = check;
                }
            }
            document.getElementById("confEdit").onclick = function(){
                check(name.value);
                if (edition == 0)
                {
                    name = document.getElementById("nameInput");
                    lvl = document.getElementById("levelInput");
                    time = document.getElementById("timeInput");
                    death = document.getElementById("deathInput");
                    date = document.getElementById("dateInput");
                    imgEdit.src =`lvl/${pngLvl[lvl.value]}.png`;
                    nameEdit = element.querySelector("[name=name]");
                    nameEdit.innerText = name.value;
                    timeEdit = element.querySelector("[name=time]");
                    timeEdit.innerText = time.value;
                    deathEdit = element.querySelector("[name=death]");
                    deathEdit.innerText = death.value;
                    dateEdit = element.querySelector("[name=date]");
                    dateEdit.innerText = date.value;
                    title.innerHTML = "Ajouter un joueur";
                    button.innerHTML = `<input type="button" id="submit" value="Confirmer">`;
                    document.getElementById("submit").onclick = check;
                    document.getElementById("form").reset();
                    sort();
                }
            }
        }
        else{
            alert("Un joueur est déjà en édition.");
        }
    };
    pasJoueur();
    sort();
}

function check(nameEdit)
{
    let errorText = "";
    let nbError = 0;
    let name = document.getElementById('nameInput');
    let lvl = document.getElementById('levelInput');
    let time = document.getElementById('timeInput');
    let death = document.getElementById('deathInput');
    let date = document.getElementById('dateInput').value;
    let timeCount = time.value.length - 1;
    let maxTime = 0;
    name.value = name.value.replace(/</g, "&lt;").replace(/>/g, "&gt;");
    if (name.value == "")
    {
        nbError++;
        errorText = errorText + "Il doit y avoir un nom.";
    }
    for (let n = 0; n < document.getElementsByName("name").length; n++)
    {
        if ((name.value == document.getElementsByName("name")[n].innerHTML) && nameEdit != name.value)
        {
            nbError++;
            if (nbError > 1)
            {
                errorText = errorText + "\n";
            }
            errorText = errorText + "Nom déjà existant.";
        }
    }
    if (pngLvl[lvl.value] == null)
    {
        nbError++;
        if (nbError > 1)
        {
            errorText = errorText + "\n";
        }
        errorText = errorText + "Il doit y avoir un niveau.";
    }
    if (time.value == "")
    {
        nbError++;
        if (nbError > 1)
        {
            errorText = errorText + "\n";
        }
        errorText = errorText + "Il doit y avoir un temps.";
    }
    while ((time.value[timeCount] != "." && time.value[timeCount] != ",") && maxTime < 3)
    {
        maxTime++;
        timeCount--;
    }
    if (maxTime > 2)
    {
        nbError++;
        if (nbError > 1)
        {
            errorText = errorText + "\n";
        }
        errorText = errorText + "Temps ne respecte pas le format(0.00).";
    }
    if (death.value == "")
    {
        nbError++;
        if (nbError > 1)
        {
            errorText = errorText + "\n";
        }
        errorText = errorText + "Il doit y avoir un nombre d'essai.";
    }
    if (death.value < 0)
    {
        nbError++;
        if (nbError > 1)
        {
            errorText = errorText + "\n";
        }
        errorText = errorText + "Le nombre d'essais ne peut pas être négatif.";
    }
    if (time.value < 0.01)
    {
        nbError++;
        if (nbError > 1)
        {
            errorText = errorText + "\n";
        }
        errorText = errorText + "Le temps est au minimum 0.01.";
    }
    if (date == false)
    {
        nbError++;
        if (nbError > 1)
        {
            errorText = errorText + "\n";
        }
        errorText = errorText + "Il doit y avoir une date.";
    }
    if (nbError > 0)
    {
        alert(`Votre ajout contient des erreurs, les voici:\n${errorText}`);
    }
    else if (edition == 0)
    {
        addPlayer();
        document.getElementById("form").reset();
    }
    else{
        edition = 0;
    }
}