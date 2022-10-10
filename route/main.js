const route = require("express")();
const tokenManager = require("./token_managers");
var mysql = require("../connect");

route.use(require("cors")());
route.use(require("express").json());

route.get("/", (req, res) => {
  res.send("Hello I am API myNote by Kiattiyot Sihawong ");
});

route.post("/get_customer_data", (req, res) => {
  let jwtStatus = tokenManager.checkAuthentication(req);
  if (jwtStatus != false) {
    let userData = req.body;
    var sql = "SELECT * FROM customer WHERE customer.id = ?";
    //console.log(sql);
    mysql.query(sql, [jwtStatus.user_id], (err, result) => {
      if (result == undefined || result.length == 0) {
        res.send(JSON.stringify({ status: "0" }));
      } else {
        if (result.length > 0) {
          res.send(JSON.stringify({ status: "1", data: result }));
        }
      }
    });
  } else {
    return false;
  }
});

route.post("/login", (req, res) => {
  let userData = req.body;
  var sql = "SELECT * FROM customer WHERE username = ? AND password = ? ";
  mysql.query(sql, [userData.username, userData.password], (err, result) => {
    if (result == undefined || result.length == 0) {
      res.send(JSON.stringify({ status: "fail" }));
    } else {
      if (result.length > 0) {
        //console.log("result[0].id :" + result[0].id);
        let accessToken = tokenManager.getGenTokhen({ user_id: result[0].id });
        res.send(JSON.stringify({ status: "ok", access_token: accessToken }));
      }
    }
  });
});

route.post("/add_note", (req, res) => {
  let jwtStatus = tokenManager.checkAuthentication(req);
  if (jwtStatus != false) {
    let userData = req.body;
    //console.log(userData);
    var sql = "INSERT INTO note SET note_name = ? , customer_id = ?";
    mysql.query(sql, [userData.note_name, jwtStatus.user_id], (err, result) => {
      if (err) {
        //console.log(err);
        return res.send({
          error: true,
          data: result,
          message: "fail",
        });
      } else {
        sql =
          "INSERT INTO history_note SET note_id = (SELECT MAX(id) FROM note) , detail = ?";
        mysql.query(sql, [userData.note_detail], (err, result) => {
          if (err) {
            return res.send({
              error: true,
              data: result,
              message: "fail",
            });
          } else {
            for (i = 0; i < userData.category_arr.length; i++) {
              sql =
                "INSERT INTO category_note SET note_id = (SELECT MAX(id) FROM note) , category_name = ?";
              mysql.query(sql, [userData.category_arr[i]], (err, result) => {
                if (err) {
                  //console.log(err);
                }
              });
            }
            return res.send({
              error: false,
              data: result,
              message: "ok",
            });
          }
        });
      }
    });
  } else {
    return false;
  }
});

route.post("/get_note_data", (req, res) => {
  let jwtStatus = tokenManager.checkAuthentication(req);
  if (jwtStatus != false) {
    let userData = req.body;
    var sql =
      "SELECT note.id,note.note_name,history_note.detail,note.time_reg,DATE_FORMAT(note.time_reg,'%d-%m-%Y') date FROM note INNER JOIN history_note ON note.id = history_note.note_id \n" +
      "WHERE note.customer_id = ?";
      //LIMIT 0,4
    mysql.query(sql, [jwtStatus.user_id], (err, result) => {
      if (err) {
        //console.log(err);
        return res.send({
          error: false,
          data: result,
          message: "fail",
        });
      } else {
        //console.log('result.length'+result.length);
        const noteSize = parseInt(result.length);
        const Show = parseInt(4);
        const pagiantionNumber = Math.round(noteSize/Show)
        return res.send({
          error: false,
          data: result,
          page_number:pagiantionNumber,
          message: "ok",
        });
      }
    });
  } else {
    return false;
  }
});
route.post("/register", (req, res) => {
  let userData = req.body;

  var sql = "INSERT INTO customer SET name = ?,surname=?,username=?,password=?";
  mysql.query(
    sql,
    [userData.name, userData.surname, userData.username, userData.password],
    (err, result) => {
      if (err) {
        //console.log(err);
        return res.send({
          error: false,
          data: result,
          message: "fail",
        });
      } else {
        return res.send({
          error: false,
          data: result,
          message: "ok",
        });
      }
    }
  );
});

route.post("/del_note", (req, res) => {
  let jwtStatus = tokenManager.checkAuthentication(req);
  if (jwtStatus != false) {
    let userData = req.body;
    // use trigger before delete (category -> history)
    var sql = "DELETE FROM note WHERE note.id = ?";
    mysql.query(sql, [userData.note_id], (err, result) => {
      if (err) {
        //console.log(err);
        return res.send({
          error: true,
          message: "fail",
        });
      } else {
        return res.send({
          error: false,
          data: result,
          message: "ok",
        });
      }
    });
  } else {
    return false;
  }
});


// route.post("/get_token/:user_id", (req, res) => {
//   res.send(tokenManager.getGenTokhen({ user_id: req.params.user_id }));
// });

// route.post("/check_authen", (req, res) => {
//   let jwtStatus = tokenManager.checkAuthentication(req);
//   if (jwtStatus != false) {
//     res.send(jwtStatus);
//   } else {
//     res.send(false);
//   }
// });

route.listen(5000, (err) => {
  console.log("Server Started!!!");
});
