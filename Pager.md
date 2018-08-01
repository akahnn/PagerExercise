# Pager Team iOS exercise

Your objective is to build an Objective-C client app that:

- Connects to an API server and fetches data from the following endpoints:
- **GET** `https://ios-hiring-backend.dokku.canillitapp.com/team`
- **GET** `https://ios-hiring-backend.dokku.canillitapp.com/roles`

- Updates the data through a socket server at: `wss://ios-hiring-backend.dokku.canillitapp.com`

- Add a button that when pressed will take you to a form style view where you can add some fields with a new user information. 

- Tapping that button will submit a JSON payload at **POST** `https://ios-hiring-backend.dokku.canillitapp.com/team`. You'll get a response and socket server will post an update too.
```
{
"name": "Emiliano Viscarra",
"avatar": "https://www.dropbox.com/s/p1qr5zqnjy4du03/emi.png?dl=1",
"github": "chompas",
"role": 1,
"gender": "Male",
"languages": ["en", "es"],
"tags": ["Objective-C", "Management"],
"location": "us"
}
```

- When a cell is touched it should go to a new controller displaying the data of the user selected.


