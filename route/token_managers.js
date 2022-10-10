const jwt = require("jsonwebtoken");
const tokenData = require("./token_data.json");
class TokhenManagers{
	static getGenTokhen(payload){
		return jwt.sign(payload,tokenData["secret_key"],{"expiresIn":"60000s"});
	}

	static checkAuthentication(request){
    	try{
            let accessToken = request.headers.authorization.split(" ")[1];
            let jwtResponse = jwt.verify(String(accessToken),tokenData["secret_key"]);
            return jwtResponse;
        }catch(error){
            return false;
        }
    }

	static getSecretKey(){
		return require("crypto").randomBytes(64).toString("hex");
	}
}

//console.log(TokhenManagers.getSecretKey());

module.exports = TokhenManagers;