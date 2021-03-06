pragma solidity ^0.5.7;

contract Cogere {

 mapping (address => uint) organisateurs;

 constructor() internal {
   organisateurs[msg.sender] = 100;   
 }

 function transfererOrga(address orga, uint parts) public {
    require(organisateurs[msg.sender] != 0, "Vous n'êtes pas un organisateur");
    require(parts <= organisateurs[msg.sender], "Vous ne pouvez pas transférer plus que votre part actuelle");
    require(organisateurs[orga] != 0, "La personne à qui vous souhaitez tranférer des parts ne fait pas partie des orginsateurs");
    organisateurs[msg.sender] -= parts;
    organisateurs[orga] += parts;
  }

 function estOrga(address orga) public view returns (bool){
    if (organisateurs[orga] > 0)
      return true;
    else
      return false;
  }
}



contract CagnotteFestival is Cogere {

 mapping (address => bool) festivaliers;
 mapping (address => string) sponsors;

 uint placesRestantes;
 uint private cagnotte;

 constructor() public {
   placesRestantes = 1000;
   cagnotte = 0;   
 }


  function acheterTicket() public payable {
   require(msg.value>= 500 finney,"Place à 0.5 Ethers");
   require(placesRestantes>0,"Plus de places !");

   placesRestantes -= 1;
   festivaliers[msg.sender]=true;

   cagnotte += msg.value;
 }

 function payer(address payable destinataire, uint montant) public {
   require(estOrga(msg.sender));
   require(destinataire != address(0));
   require(montant > 0);
   destinataire.transfer(montant);
 }

 function sponsoriser(string memory nom) public payable {
  require(msg.value >= 30 ether, "Pour être cité comme sponsor, un paiement de 30 ethers minimum est requis");

  cagnotte += msg.value;
  sponsors[msg.sender] = nom;

 }

}
