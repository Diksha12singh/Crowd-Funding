// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract EventContract{
    struct Event{
        address oraganizer ;
        string name ;
        uint date ;
        uint price ;
        uint ticketcount;
        uint ticketremain;
    }
    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public tickets ;
    uint public nextId ;


    function createvent(string memory name,uint date, uint price, uint ticketcount) external {
        require(date>block.timestamp,"You can organize event for future date");
        require(ticketcount>0,"You can organize event  only if you create more than 0 tickets");
        events[nextId] = Event(msg.sender,name,date,price,ticketcount,ticketcount) ;
        nextId++;
    }

    function buyTicket(uint id, uint quantity)external payable{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event= events[id];
        require(msg.value==(_event.price*quantity),"Ethere is not enough");
        require(_event.ticketremain>=quantity,"Not enough tickets");
        _event.ticketremain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
}
