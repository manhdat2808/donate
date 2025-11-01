// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract DirectDonation {
    string public campaignName;
    string public description;
    uint256 public totalRaised;

    event Donated(address indexed donor, address indexed recipient, uint256 amount);

    constructor(string memory _name, string memory _desc) {
        campaignName = _name;
        description = _desc;
    }

    // GỬI TRỰC TIẾP CHO VÍ KHÁC
    function donateTo(address recipient) external payable {
        require(msg.value > 0, "Must send cUSD");
        require(recipient != address(0), "Invalid address");

        totalRaised += msg.value;

        (bool success, ) = recipient.call{value: msg.value}("");
        require(success, "Transfer failed");

        emit Donated(msg.sender, recipient, msg.value);
    }

    // Xem thông tin
    function getInfo() external view returns (string memory, string memory, uint256) {
        return (campaignName, description, totalRaised);
    }
}