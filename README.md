# Attribute based access control

The `friendbook` sample demonstrates the use of Hyperledger Fabric basic features by saving assets (messages) to the state and retrieving either all of them or only the messages that were sent to the organization issuing the query transaction

## Start the network and deploy the chaincode

We can use the Fabric test network to deploy and interact with the `friendbook` chaincode. Run the following command to change into the test network directory and 

-Follow the installation guide https://hyperledger-fabric.readthedocs.io/en/release-2.2/prereqs.html and the `test-network` setup guide https://hyperledger-fabric.readthedocs.io/en/release-2.2/test_network.html

-Bring down any running nodes:
```
cd fabric-samples/test-network
./network.sh down
```

-Change the directory to the `test-network` directory:
```
cd ./fabric-samples/test-network/
```

-Run the following command to deploy the test network using Certificate Authorities:
```
./network.sh up createChannel
```

-clone the `friendbook` repo into the `test-network` directory:

-You can then use the test network script to deploy the `friendbook` chaincode to a channel on the network:
```
./network.sh deployCC -ccn basic -ccp ./friendbook/ -ccl javascript
```
## Invoking Chaincode

-Export peer binaries and core.yaml path:
```
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
```

-Export Org1 environment variables
```
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
```

-Call CreateMessage Function
```
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n friendbook --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"CreateMessage","Args":["message1","Hi","Org2MSP"]}'

peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n friendbook --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"CreateMessage","Args":["message2","Talking to myself!","Org1MSP"]}'
```

-Query all created messages
```
peer chaincode query -C mychannel -n friendbook -c '{"Args":["GetAllMessages"]}'
```

-Query messages which should be received by Org1
```
peer chaincode query -C mychannel -n friendbook -c '{"Args":["GetMyMessages"]}'
```

-Export Org2 environment variables
```
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
```

-Query messages which should be received by Org2
```
peer chaincode query -C mychannel -n friendbook -c '{"Args":["GetMyMessages"]}'
```

## Clean up

When you are finished, you can run the following command to bring down the test network:
```
./network.sh down
```
