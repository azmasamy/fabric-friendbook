#!/bin/bash 
echo -e "\n\n--------------- Stopping test network ---------------\n\n"
./network.sh down
echo -e "\n\n--------------- Starting test network ---------------\n\n"
./network.sh up createChannel
echo -e "\n\n--------------- deploying chaincode ---------------\n\n"
./network.sh deployCC -ccn friendbook -ccp ../../fabric-projects/basic-chaincode/ -ccl javascript
echo -e "\n\n--------------- Setting peer binaries and enviroment variables---------------\n\n"
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
echo -e "\n\n--------------- Creating a message ---------------\n\n"
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n friendbook --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"CreateMessage","Args":["Hi","Org2"]}'
echo -e "\n\n--------------- Getting all messages ---------------\n\n"
peer chaincode query -C mychannel -n friendbook -c '{"Args":["GetAllMessages"]}'