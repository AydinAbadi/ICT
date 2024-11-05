{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red172\green172\blue193;\red0\green0\blue0;\red79\green123\blue61;
\red70\green137\blue204;\red212\green212\blue212;\red167\green197\blue152;\red45\green175\blue118;\red237\green114\blue173;
\red13\green102\blue149;\red194\green126\blue101;\red253\green181\blue13;\red31\green133\blue64;\red14\green86\blue166;
\red187\green97\blue44;\red76\green167\blue134;\red140\green108\blue11;}
{\*\expandedcolortbl;;\cssrgb\c72941\c73333\c80000;\csgray\c0\c0;\cssrgb\c37647\c54510\c30588;
\cssrgb\c33725\c61176\c83922;\cssrgb\c86275\c86275\c86275;\cssrgb\c70980\c80784\c65882;\cssrgb\c19608\c72941\c53725;\cssrgb\c95294\c54118\c73333;
\cssrgb\c0\c47843\c65098;\cssrgb\c80784\c56863\c47059;\cssrgb\c100000\c75686\c2745;\cssrgb\c12941\c58039\c31765;\cssrgb\c3137\c42353\c70980;
\cssrgb\c78824\c45882\c22353;\cssrgb\c35686\c70588\c59608;\cssrgb\c61961\c49412\c3137;}
\paperw11900\paperh16840\margl1440\margr1440\vieww34240\viewh13900\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs31\fsmilli15600 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf4 \strokec4 // SPDX-License-Identifier: MIT\cf2 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf5 \strokec5 pragma\cf2 \strokec2  \cf5 \strokec5 solidity\cf2 \strokec2  \cf6 \strokec6 ^\cf7 \strokec7 0.8.0\cf6 \strokec6 ;\cf2 \strokec2 \
\cf5 \strokec5 contract\cf2 \strokec2  ICE_Contract \cf6 \strokec6 \{\cf2 \strokec2 \
\
\pard\pardeftab720\partightenfactor0
\cf4 \strokec4 //////////// In this prototype we assume the server agrees with the initial request of the client (during c.init and s.init phases)\cf2 \strokec2 \
    \cf4 \strokec4 // struct Init_Transactoin\{\cf2 \strokec2 \
    \cf4 \strokec4 //     string source_currency;\cf2 \strokec2 \
    \cf4 \strokec4 //     string destination_currency;\cf2 \strokec2 \
    \cf4 \strokec4 //     address client;\cf2 \strokec2 \
    \cf4 \strokec4 //     address server; \cf2 \strokec2 \
    \cf4 \strokec4 //     bool approved_by_server;\cf2 \strokec2 \
    \cf4 \strokec4 // \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // Struct to store transaction details\cf2 \strokec2 \
    \cf5 \strokec5 struct\cf2 \strokec2  Transaction \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  amount\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // The total amount (including premuim it transfers)\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  req\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // The amount the client wants to exchange\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  premium\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // The amount of premium the client pays-- one may be tempted to calculate premuim amount as:  amount - req. However, this naive approach may not work if the amunt if premuim is decided on the fly based on up-to-date market information\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  timestamp\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  set_approved\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // This flag is used to make sure the server can set the value of approved_by_server only once\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  votes\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // It keeps the total votes (in favour of the client) provided by auditors\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  auditors_counter\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // It counts the number of auditors voted (so far)\cf2 \strokec2 \
        \cf5 \strokec5 address\cf2 \strokec2  server\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // The address of the server with which the client wants to interact\cf2 \strokec2 \
        \cf5 \strokec5 bytes32\cf2 \strokec2  transactionId\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 bytes32\cf2 \strokec2  evidence\cf6 \strokec6 ;\cf4 \strokec4 // Provided by the client in the case of complaint\cf2 \strokec2 \
        \cf4 \strokec4 //bytes32 server_evidence;// Provided by the server, when it delivers the service\cf2 \strokec2 \
        \cf4 \strokec4 //bytes32 initial_transaction_id;// This random number will be generated locally by the client when it calls client_init() (resulting in creating an instance of \cf2 \strokec2 \
        \cf4 \strokec4 // Init_Transactoin. The client needs to also provide this id when it calls sendTransaction() which sets field  initial_transaction_id to this id when\cf2 \strokec2 \
        \cf4 \strokec4 // an instance of Transaction is created for it. This approach allows the smart contract to connect Transaction to Init_Transactoin (check if the server has initially accepted cleints initial request) in server_init\cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  pending\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // To track if the transaction is pending\cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  approved_by_server\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  transferred\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // It determines if the client's amount has already been transferred to the server \cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  complaint_made\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // It determines if a client has made a complaint about this transaction\cf2 \strokec2 \
\
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 struct\cf2 \strokec2  Pending_transaction\cf6 \strokec6 \{\cf2 \strokec2 \
        \cf5 \strokec5 address\cf2 \strokec2  clientAddress\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  index\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // The position of the transaction in the array: transactions...\cf2 \strokec2 \
        \cf4 \strokec4 //... Given the index and a client's address one can find the infomration about that particular transaction     \cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 struct\cf2 \strokec2  Auditor_voting_rec\cf6 \strokec6 \{\cf2 \strokec2 \
        \cf5 \strokec5 address\cf2 \strokec2  client\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 bytes32\cf2 \strokec2  transactionId\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  voted\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf4 \strokec4 //mapping(bytes32 => Init_Transactoin) public initial_trnasactions; // It includes the initial transaction that the client makes and\cf2 \strokec2 \
    \cf4 \strokec4 // sends to the smart contract (in Phase 4, C.Init()). To access its content a user locally generates a random bytes32.  \cf2 \strokec2 \
    \cf5 \strokec5 mapping\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  => Auditor_voting_rec\cf6 \strokec6 [])\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  auditor_votes\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf4 \strokec4 // Mapping from an address to an array of transactions\cf2 \strokec2 \
    \cf5 \strokec5 mapping\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  => Transaction\cf6 \strokec6 [])\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  transactions\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf5 \strokec5 mapping\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2 => \cf5 \strokec5 uint256\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  riskFactor\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // For the sake of simplicity, set the riskfactor to a valud between 1 and 10. \cf2 \strokec2 \
    \cf5 \strokec5 mapping\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2 => \cf5 \strokec5 uint256\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  auditorsList\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // A list of registered auditors\cf2 \strokec2 \
    \cf5 \strokec5 mapping\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2 => \cf5 \strokec5 uint256\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  serversList\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // A list of registered resvers\cf2 \strokec2 \
    \cf5 \strokec5 mapping\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  => \cf5 \strokec5 uint\cf6 \strokec6 [])\cf2 \strokec2   \cf8 \strokec8 public\cf2 \strokec2  clientsPaidPremuim\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // Keeps track of how many time and how much each client paid premuim\cf2 \strokec2 \
    \cf5 \strokec5 mapping\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  => \cf5 \strokec5 uint256\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  balances\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // To track how much each address has sent\cf2 \strokec2 \
\
    \cf5 \strokec5 uint256\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  threshold\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // It determines the maximum number of corrupt auditors\cf2 \strokec2 \
    \cf5 \strokec5 uint256\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  auditorCount\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // Counter to track the number of registered auditors\cf2 \strokec2 \
    \cf5 \strokec5 uint256\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  min_number_of_auditors\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // Determines the minumum number of auditors required to compile a complaint\cf2 \strokec2 \
    \cf5 \strokec5 uint256\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  serverCount\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // Counter to track the number of registered servers\cf2 \strokec2 \
    \cf5 \strokec5 uint256\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  coverage\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // This is in percent of the full transaction amount covered by the policy, e.g., 0.5-- we use integer rather than floting point to define it. In calculation we will use \cf2 \strokec2 \
    \cf4 \strokec4 // coverage/100\cf2 \strokec2 \
    \cf5 \strokec5 uint256\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  policy_duration\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // For simplicity we have fixed the duration of the policy for all clients\cf2 \strokec2 \
    \cf5 \strokec5 uint256\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  delta\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // The period within which a client can withdraw an amount it has transferred\cf2 \strokec2 \
    \cf5 \strokec5 address\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  owner\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // The address of the owner of the smart contract, i.e., the operator, who deploys it. \cf2 \strokec2 \
    Pending_transaction\cf6 \strokec6 []\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  globalPendingTransactions\cf6 \strokec6 ;\cf2 \strokec2 \
\
    \cf9 \strokec9 constructor\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  min_number_of_auditors_\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        owner \cf6 \strokec6 =\cf2 \strokec2  \cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // msg.sender is the address that deploys the contract\cf2 \strokec2 \
        min_number_of_auditors \cf6 \strokec6 =\cf2 \strokec2  min_number_of_auditors_\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 modifier\cf2 \strokec2  onlyOwner\cf6 \strokec6 ()\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender \cf6 \strokec6 ==\cf2 \strokec2  owner\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Caller is not the owner"\cf6 \strokec6 );\cf2 \strokec2 \
        _\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  contributeCapital\cf6 \strokec6 ()\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf8 \strokec8 payable\cf2 \strokec2   \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 value \cf6 \strokec6 >\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Contribution must be greater than 0"\cf6 \strokec6 );\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  setDuration\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  policy_duration_\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 uint256\cf2 \strokec2  delta_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  onlyOwner \cf6 \strokec6 \{\cf2 \strokec2 \
        policy_duration \cf6 \strokec6 =\cf2 \strokec2  policy_duration_\cf6 \strokec6 ;\cf2 \strokec2 \
        delta \cf6 \strokec6 =\cf2 \strokec2  delta_\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  setCoverage\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  coverage_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  onlyOwner \cf6 \strokec6 \{\cf2 \strokec2 \
        coverage \cf6 \strokec6 =\cf2 \strokec2  coverage_\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  setThreshold\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  threshold_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  onlyOwner \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf12 \strokec12 if\cf6 \strokec6 ((\cf2 \strokec2 threshold_ \cf6 \strokec6 *\cf2 \strokec2  auditorCount\cf6 \strokec6 )/\cf7 \strokec7 100\cf2 \strokec2  \cf6 \strokec6 <=\cf2 \strokec2  auditorCount\cf6 \strokec6 /\cf7 \strokec7 3\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            threshold \cf6 \strokec6 =\cf2 \strokec2  threshold_\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  setAuditor\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  auditor\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  onlyOwner\cf6 \strokec6 \{\cf2 \strokec2 \
        \cf12 \strokec12 if\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 auditorsList\cf6 \strokec6 [\cf2 \strokec2 auditor\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            auditorCount\cf6 \strokec6 ++;\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
        auditorsList\cf6 \strokec6 [\cf2 \strokec2 auditor\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  setServer\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  server\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  onlyOwner\cf6 \strokec6 \{\cf2 \strokec2 \
        \cf12 \strokec12 if\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 serversList\cf6 \strokec6 [\cf2 \strokec2 server\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            serverCount\cf6 \strokec6 ++;\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
        serversList\cf6 \strokec6 [\cf2 \strokec2 server\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  setRiskFactor\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  server\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 uint256\cf2 \strokec2  risk_factor\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  onlyOwner \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf2 \strokec2 serversList\cf6 \strokec6 [\cf2 \strokec2 server\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 1\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  risk_factor \cf6 \strokec6 >=\cf2 \strokec2  \cf7 \strokec7 1\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  risk_factor \cf6 \strokec6 <=\cf2 \strokec2  \cf7 \strokec7 10\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Error: the server has not been registered"\cf6 \strokec6 );\cf2 \strokec2 \
        riskFactor\cf6 \strokec6 [\cf2 \strokec2 server\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 =\cf2 \strokec2  risk_factor\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  getBalance\cf6 \strokec6 ()\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf8 \strokec8 view\cf2 \strokec2  \cf13 \strokec13 returns\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 uint256\cf6 \strokec6 )\{\cf2 \strokec2 \
        \cf13 \strokec13 return\cf2 \strokec2   \cf5 \strokec5 address\cf6 \strokec6 (\cf14 \strokec14 this\cf6 \strokec6 ).\cf2 \strokec2 balance\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  castVote\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  vote\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 address\cf2 \strokec2  client_address\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 bytes32\cf2 \strokec2  transactionId_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 internal\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf2 \strokec2 vote \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 1\cf2 \strokec2  \cf6 \strokec6 ||\cf2 \strokec2  vote \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Invalid input-- The value of vote must be 0 or 1"\cf6 \strokec6 );\cf2 \strokec2  \cf4 \strokec4 // Check if the vote's format is correct, i.e., it's 0 or 1\cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf2 \strokec2 auditorsList\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Invalid auditor-- The auditor must be registered"\cf6 \strokec6 );\cf2 \strokec2  \cf4 \strokec4 // Check if the auditor has been registered    \cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  not_continu\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  not_continu_\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf4 \strokec4 // Check if the auditor has not already voted for this client's transaction-- otherwise do not continue\cf2 \strokec2 \
        \cf15 \strokec15 for\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  j \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  j \cf6 \strokec6 <\cf2 \strokec2  auditor_votes\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 !\cf2 \strokec2 not_continu_\cf6 \strokec6 ;\cf2 \strokec2  j\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 auditor_votes\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 j\cf6 \strokec6 ].\cf2 \strokec2 client \cf6 \strokec6 ==\cf2 \strokec2  client_address \cf6 \strokec6 &&\cf2 \strokec2  \
            auditor_votes\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 j\cf6 \strokec6 ].\cf2 \strokec2 transactionId \cf6 \strokec6 ==\cf2 \strokec2  transactionId_ \cf6 \strokec6 &&\cf2 \strokec2 \
            auditor_votes\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 j\cf6 \strokec6 ].\cf2 \strokec2 voted \cf6 \strokec6 ==\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            not_continu_ \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 ;\cf2 \strokec2 \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf12 \strokec12 if\cf6 \strokec6 (!\cf2 \strokec2 not_continu_\cf6 \strokec6 )\{\cf2 \strokec2 \
            \cf4 \strokec4 // record the auditor's vote in the transaction\cf2 \strokec2 \
            \cf15 \strokec15 for\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  i \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  i \cf6 \strokec6 <\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 !\cf2 \strokec2 not_continu\cf6 \strokec6 ;\cf2 \strokec2  i\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 transactionId \cf6 \strokec6 ==\cf2 \strokec2  transactionId_ \cf6 \strokec6 &&\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 complaint_made \cf6 \strokec6 ==\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                    transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 votes \cf6 \strokec6 +=\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
                    transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 auditors_counter \cf6 \strokec6 +=\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
                    auditor_votes\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ].\cf2 \strokec2 push\cf6 \strokec6 (\cf2 \strokec2 Auditor_voting_rec\cf6 \strokec6 (\{\cf2 \strokec2 client\cf6 \strokec6 :\cf2 \strokec2  client_address\cf6 \strokec6 ,\cf2 \strokec2  transactionId\cf6 \strokec6 :\cf2 \strokec2  transactionId_\cf6 \strokec6 ,\cf2 \strokec2  voted \cf6 \strokec6 :\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 \}));\cf2 \strokec2  \cf4 \strokec4 // Record the auditor's vote in auditor_votes\cf2 \strokec2 \
                    not_continu \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 ;\cf2 \strokec2 \
                \cf6 \strokec6 \}\cf2 \strokec2 \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // function client_init(string memory source_currency_, string memory destination_currency_, bytes32 rand_id, address server_) public\{\cf2 \strokec2 \
    \cf4 \strokec4 //     initial_trnasactions[rand_id] = Init_Transactoin(\{source_currency: source_currency_, destination_currency: destination_currency_, \cf2 \strokec2 \
    \cf4 \strokec4 //     client: msg.sender, server: server_, approved_by_server: false\});\cf2 \strokec2 \
    \cf4 \strokec4 // \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // function server_init(bytes32 rand_id, address client_, bool response) public \{\cf2 \strokec2 \
    \cf4 \strokec4 //     require(initial_trnasactions[rand_id].client == client_ && initial_trnasactions[rand_id].server == msg.sender, "Error--invalid informaiton");\cf2 \strokec2 \
    \cf4 \strokec4 //     initial_trnasactions[rand_id].approved_by_server = response;\cf2 \strokec2 \
    \cf4 \strokec4 // \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // function calPremium(uint256 transactionValue, address server) public view returns(uint256) \{\cf2 \strokec2 \
    \cf4 \strokec4 //     //uint256 premium = transactionValue * riskFactor[server] * policy_duration * coverage / 100;\cf2 \strokec2 \
    \cf4 \strokec4 //     return transactionValue * riskFactor[server] * policy_duration * coverage / 100;\cf2 \strokec2 \
    \cf4 \strokec4 // \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  calPremium\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  transactionValue\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 address\cf2 \strokec2  server\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf8 \strokec8 view\cf2 \strokec2  \cf13 \strokec13 returns\cf6 \strokec6 (\cf5 \strokec5 uint256\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf4 \strokec4 // Scale factor to simulate decimal calculations (e.g., 1000 for 3 decimal places)\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  scaleFactor \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 1000000\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  riskAdjustment \cf6 \strokec6 =\cf2 \strokec2  riskFactor\cf6 \strokec6 [\cf2 \strokec2 server\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 *\cf2 \strokec2  \cf7 \strokec7 30\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf4 \strokec4 // Adjust policy duration impact: cap the duration influence to avoid exponential growth\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  durationAdjustment \cf6 \strokec6 =\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 policy_duration \cf6 \strokec6 <\cf2 \strokec2  \cf7 \strokec7 3\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 ?\cf2 \strokec2  policy_duration \cf6 \strokec6 *\cf2 \strokec2  \cf7 \strokec7 30\cf2 \strokec2  \cf6 \strokec6 :\cf2 \strokec2  policy_duration \cf6 \strokec6 *\cf2 \strokec2  \cf7 \strokec7 40\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // Equivalent to `policy_duration * 0.01`\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  temp \cf6 \strokec6 =\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactionValue \cf6 \strokec6 *\cf2 \strokec2  riskAdjustment \cf6 \strokec6 *\cf2 \strokec2  durationAdjustment \cf6 \strokec6 *\cf2 \strokec2  coverage\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 /\cf2 \strokec2  scaleFactor\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf12 \strokec12 if\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 temp \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            temp \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf13 \strokec13 return\cf2 \strokec2  temp\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  extractVerdict\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  client_address\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 uint256\cf2 \strokec2  index\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf8 \strokec8 view\cf2 \strokec2  \cf13 \strokec13 returns\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 uint256\cf6 \strokec6 )\{\cf2 \strokec2 \
        \cf4 \strokec4 //bool not_continu;\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  res \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 >\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Error: the client has made no transaction"\cf6 \strokec6 );\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  temp \cf6 \strokec6 =\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 index\cf6 \strokec6 ].\cf2 \strokec2 auditors_counter \cf6 \strokec6 -\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 index\cf6 \strokec6 ].\cf2 \strokec2 auditors_counter \cf6 \strokec6 *\cf2 \strokec2  threshold\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 /\cf2 \strokec2  \cf7 \strokec7 100\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 index\cf6 \strokec6 ].\cf2 \strokec2 votes \cf6 \strokec6 >=\cf2 \strokec2   temp\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            res \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf13 \strokec13 return\cf2 \strokec2  res\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // function extractVerdict(address client_address, bytes32 transactionId_) public view returns (uint256)\{\cf2 \strokec2 \
    \cf4 \strokec4 //     bool not_continu;\cf2 \strokec2 \
    \cf4 \strokec4 //     uint256 res = 0;\cf2 \strokec2 \
    \cf4 \strokec4 //     for(uint256 i = 0; i < transactions[client_address].length && !not_continu; i++) \{\cf2 \strokec2 \
    \cf4 \strokec4 //         // Check if the total number of votes infavour of the client is greater than equal to auditors_counter*(1-threshold/100)\cf2 \strokec2 \
    \cf4 \strokec4 //         if(transactions[client_address][i].transactionId == transactionId_)\{\cf2 \strokec2 \
    \cf4 \strokec4 //             uint256 temp = transactions[client_address][i].auditors_counter - (transactions[client_address][i].auditors_counter * threshold) / 100;\cf2 \strokec2 \
    \cf4 \strokec4 //             if(transactions[client_address][i].votes >=  temp) \{\cf2 \strokec2 \
    \cf4 \strokec4 //                 res = 1;\cf2 \strokec2 \
    \cf4 \strokec4 //             \}\cf2 \strokec2 \
    \cf4 \strokec4 //             not_continu = true;\cf2 \strokec2 \
    \cf4 \strokec4 //         \}\cf2 \strokec2 \
    \cf4 \strokec4 //     \}\cf2 \strokec2 \
    \cf4 \strokec4 //     return res;\cf2 \strokec2 \
    \cf4 \strokec4 // \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  addPremuim\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  client\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 uint256\cf2 \strokec2  amount\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 internal\cf6 \strokec6 \{\cf2 \strokec2 \
        clientsPaidPremuim\cf6 \strokec6 [\cf2 \strokec2 client\cf6 \strokec6 ].\cf2 \strokec2 push\cf6 \strokec6 (\cf2 \strokec2 amount\cf6 \strokec6 );\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  compRemAmount\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  coverage_\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 uint256\cf2 \strokec2  transaction_amount\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf8 \strokec8 pure\cf2 \strokec2  \cf13 \strokec13 returns\cf6 \strokec6 (\cf5 \strokec5 uint256\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf4 \strokec4 // in future we may need to change "pure" to something else\cf2 \strokec2 \
        \cf13 \strokec13 return\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 coverage_ \cf6 \strokec6 *\cf2 \strokec2  transaction_amount\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 /\cf2 \strokec2  \cf7 \strokec7 100\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  regComplaint\cf6 \strokec6 (\cf5 \strokec5 bytes32\cf2 \strokec2  evidence_\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 bytes32\cf2 \strokec2  transactionId_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  not_continu\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf15 \strokec15 for\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  i \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  i \cf6 \strokec6 <\cf2 \strokec2  transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 !\cf2 \strokec2 not_continu\cf6 \strokec6 ;\cf2 \strokec2  i\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 transactionId \cf6 \strokec6 ==\cf2 \strokec2  transactionId_\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 complaint_made \cf6 \strokec6 ==\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 complaint_made \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 ;\cf2 \strokec2 \
                transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 evidence \cf6 \strokec6 =\cf2 \strokec2  evidence_\cf6 \strokec6 ;\cf2 \strokec2 \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // The client needs to transfer a correct amount of coin via this function. Specifically, it needs to transfer amunt: req_ + premium (recall that this function is payable and the cleint can directly send coins when calling this function\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  sendTransaction \cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  server_\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 uint256\cf2 \strokec2  req_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf8 \strokec8 payable\cf6 \strokec6 \{\cf2 \strokec2  \cf4 \strokec4 // for the sake of simplicity, we let "req" contain only the value the client wants to exchange \cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 value \cf6 \strokec6 >\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "You must send some Ether"\cf6 \strokec6 );\cf2 \strokec2 \
        \cf4 \strokec4 // Check if (1) a sufficient amount has been transferred, (2) the client wants to interact with a registered server, or (3) the contract has enough budget to serve the client\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  prem \cf6 \strokec6 =\cf2 \strokec2  calPremium\cf6 \strokec6 (\cf2 \strokec2 req_\cf6 \strokec6 ,\cf2 \strokec2  server_\cf6 \strokec6 );\cf2 \strokec2 \
        \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2  \cf6 \strokec6 (\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 value \cf6 \strokec6 <\cf2 \strokec2  prem \cf6 \strokec6 +\cf2 \strokec2  req_\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 ||\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 serversList\cf6 \strokec6 [\cf2 \strokec2 server_\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 !=\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 ||\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 checkBudget\cf6 \strokec6 (\cf2 \strokec2 req_\cf6 \strokec6 ,\cf2 \strokec2  server_\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ))\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2  \
            \cf8 \strokec8 payable\cf6 \strokec6 (\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ).\cf2 \strokec2 transfer\cf6 \strokec6 (\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 value\cf6 \strokec6 );\cf2 \strokec2  \cf4 \strokec4 // If any of the above three conditions are not met, it refunds the client \cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf12 \strokec12 else\cf6 \strokec6 \{\cf2 \strokec2 \
            updatePendingTransaction\cf6 \strokec6 ();\cf2 \strokec2 \
            balances\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ]\cf2 \strokec2  \cf6 \strokec6 +=\cf2 \strokec2  \cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 value\cf6 \strokec6 ;\cf2 \strokec2  \cf4 \strokec4 // Update the client's balance\cf2 \strokec2 \
            \cf4 \strokec4 // Creates a transaction (of type struct) for the payment the client made\cf2 \strokec2 \
            \cf5 \strokec5 bytes32\cf2 \strokec2  transactionId \cf6 \strokec6 =\cf2 \strokec2  \cf10 \strokec10 keccak256\cf6 \strokec6 (\cf10 \strokec10 abi\cf6 \strokec6 .\cf2 \strokec2 encodePacked\cf6 \strokec6 (\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ,\cf2 \strokec2  \cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 value\cf6 \strokec6 ,\cf2 \strokec2  \cf10 \strokec10 block\cf6 \strokec6 .\cf2 \strokec2 number\cf6 \strokec6 ,\cf2 \strokec2  \cf10 \strokec10 block\cf6 \strokec6 .\cf2 \strokec2 timestamp\cf6 \strokec6 ));\cf2 \strokec2 \
            transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ].\cf2 \strokec2 push\cf6 \strokec6 (\cf2 \strokec2 Transaction\cf6 \strokec6 (\{\cf2 \strokec2 amount\cf6 \strokec6 :\cf2 \strokec2  \cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 value\cf6 \strokec6 ,\cf2 \strokec2  req\cf6 \strokec6 :\cf2 \strokec2  req_\cf6 \strokec6 ,\cf2 \strokec2  premium\cf6 \strokec6 :\cf2 \strokec2  prem\cf6 \strokec6 ,\cf2 \strokec2  \
            transactionId\cf6 \strokec6 :\cf2 \strokec2  transactionId\cf6 \strokec6 ,\cf2 \strokec2  timestamp\cf6 \strokec6 :\cf2 \strokec2  \cf10 \strokec10 block\cf6 \strokec6 .\cf2 \strokec2 timestamp\cf6 \strokec6 ,\cf2 \strokec2  pending\cf6 \strokec6 :\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 ,\cf2 \strokec2  server\cf6 \strokec6 :\cf2 \strokec2  server_\cf6 \strokec6 ,\cf2 \strokec2  \
            approved_by_server\cf6 \strokec6 :\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ,\cf2 \strokec2  set_approved\cf6 \strokec6 :\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ,\cf2 \strokec2  votes\cf6 \strokec6 :\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ,\cf2 \strokec2  transferred\cf6 \strokec6 :\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ,\cf2 \strokec2  complaint_made\cf6 \strokec6 :\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ,\cf2 \strokec2  evidence\cf6 \strokec6 :\cf2 \strokec2  \cf16 \strokec16 0x0\cf6 \strokec6 ,\cf2 \strokec2  auditors_counter\cf6 \strokec6 :\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 \}));\cf2 \strokec2  \cf4 \strokec4 // Store the transaction details in the mapping\cf2 \strokec2 \
            \cf5 \strokec5 uint256\cf2 \strokec2  index_ \cf6 \strokec6 =\cf2 \strokec2  transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 -\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
            globalPendingTransactions\cf6 \strokec6 .\cf2 \strokec2 push\cf6 \strokec6 (\cf2 \strokec2 Pending_transaction\cf6 \strokec6 (\{\cf2 \strokec2 clientAddress\cf6 \strokec6 :\cf2 \strokec2  \cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ,\cf2 \strokec2  index\cf6 \strokec6 :\cf2 \strokec2  index_\cf6 \strokec6 \}));\cf4 \strokec4 // Adds the request to the pending transaction list.\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // Given an address of a client and index (i-th transaction made by the owner of address), it returns the transaction details\cf2 \strokec2 \
    \cf5 \strokec5 function\cf2 \strokec2  getTransactionByIndex\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  address_\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 uint256\cf2 \strokec2  index\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf8 \strokec8 view\cf2 \strokec2  \cf13 \strokec13 returns\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 Transaction \cf17 \strokec17 memory\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf2 \strokec2 index \cf6 \strokec6 <\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 address_\cf6 \strokec6 ].\cf2 \strokec2 length\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Invalid index"\cf6 \strokec6 );\cf2 \strokec2 \
        \cf13 \strokec13 return\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 address_\cf6 \strokec6 ][\cf2 \strokec2 index\cf6 \strokec6 ];\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  updatePendingTransaction\cf6 \strokec6 ()\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  currentTime \cf6 \strokec6 =\cf2 \strokec2  \cf10 \strokec10 block\cf6 \strokec6 .\cf2 \strokec2 timestamp\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf4 \strokec4 // Iterate over the global pending transactions\cf2 \strokec2 \
        \cf15 \strokec15 for\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  i \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  i \cf6 \strokec6 <\cf2 \strokec2  globalPendingTransactions\cf6 \strokec6 .\cf2 \strokec2 length\cf6 \strokec6 ;\cf2 \strokec2  i\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            \cf4 \strokec4 //transactions[globalPendingTransactions[i].clientAddress];\cf2 \strokec2 \
            \cf5 \strokec5 address\cf2 \strokec2  address_ \cf6 \strokec6 =\cf2 \strokec2  globalPendingTransactions\cf6 \strokec6 [\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 clientAddress\cf6 \strokec6 ;\cf2 \strokec2 \
            \cf5 \strokec5 uint256\cf2 \strokec2  size \cf6 \strokec6 =\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 address_\cf6 \strokec6 ].\cf2 \strokec2 length\cf6 \strokec6 ;\cf2 \strokec2 \
            \cf15 \strokec15 for\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  j \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  j \cf6 \strokec6 <\cf2 \strokec2  size\cf6 \strokec6 ;\cf2 \strokec2  j\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 currentTime \cf6 \strokec6 -\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 address_\cf6 \strokec6 ][\cf2 \strokec2 j\cf6 \strokec6 ].\cf2 \strokec2 timestamp \cf6 \strokec6 >\cf2 \strokec2  \cf7 \strokec7 365\cf2 \strokec2  \cf6 \strokec6 *\cf2 \strokec2  \cf7 \strokec7 24\cf2 \strokec2  \cf6 \strokec6 *\cf2 \strokec2  \cf7 \strokec7 60\cf2 \strokec2  \cf6 \strokec6 *\cf2 \strokec2  \cf7 \strokec7 60\cf2 \strokec2  \cf6 \strokec6 *\cf2 \strokec2  policy_duration\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                    transactions\cf6 \strokec6 [\cf2 \strokec2 address_\cf6 \strokec6 ][\cf2 \strokec2 j\cf6 \strokec6 ].\cf2 \strokec2 pending \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ;\cf2 \strokec2 \
                \cf6 \strokec6 \}\cf2 \strokec2 \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  getTotalPendingTransactionAmount\cf6 \strokec6 ()\cf2 \strokec2   \cf8 \strokec8 internal\cf2 \strokec2  \cf8 \strokec8 view\cf2 \strokec2  \cf13 \strokec13 returns\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 uint256\cf6 \strokec6 )\{\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  totalPendingTransAmount \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  \
        \cf15 \strokec15 for\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  i \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  i \cf6 \strokec6 <\cf2 \strokec2  globalPendingTransactions\cf6 \strokec6 .\cf2 \strokec2 length\cf6 \strokec6 ;\cf2 \strokec2  i\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2           \
            \cf5 \strokec5 address\cf2 \strokec2  address_ \cf6 \strokec6 =\cf2 \strokec2  globalPendingTransactions\cf6 \strokec6 [\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 clientAddress\cf6 \strokec6 ;\cf2 \strokec2 \
            \cf5 \strokec5 uint256\cf2 \strokec2  index_ \cf6 \strokec6 =\cf2 \strokec2  globalPendingTransactions\cf6 \strokec6 [\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 index\cf6 \strokec6 ;\cf2 \strokec2 \
            \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 address_\cf6 \strokec6 ][\cf2 \strokec2 index_\cf6 \strokec6 ].\cf2 \strokec2 pending \cf6 \strokec6 ==\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                totalPendingTransAmount \cf6 \strokec6 +=\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 address_\cf6 \strokec6 ][\cf2 \strokec2 index_\cf6 \strokec6 ].\cf2 \strokec2 amount\cf6 \strokec6 ;\cf2 \strokec2  \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf13 \strokec13 return\cf2 \strokec2  totalPendingTransAmount\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  totalCompensasionAmount\cf6 \strokec6 ()\cf2 \strokec2  \cf8 \strokec8 internal\cf2 \strokec2  \cf8 \strokec8 view\cf2 \strokec2  \cf13 \strokec13 returns\cf2 \strokec2  \cf6 \strokec6 (\cf5 \strokec5 uint256\cf6 \strokec6 )\{\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  val \cf6 \strokec6 =\cf2 \strokec2  getTotalPendingTransactionAmount\cf6 \strokec6 ();\cf2 \strokec2 \
        \cf13 \strokec13 return\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 coverage\cf6 \strokec6 /\cf7 \strokec7 100\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 *\cf2 \strokec2  val\cf6 \strokec6 ;\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  checkBudget\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  transactionValue\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 address\cf2 \strokec2  server\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf8 \strokec8 view\cf2 \strokec2  \cf13 \strokec13 returns\cf6 \strokec6 (\cf5 \strokec5 uint256\cf6 \strokec6 )\{\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  res  \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  premium \cf6 \strokec6 =\cf2 \strokec2  calPremium\cf6 \strokec6 (\cf2 \strokec2 transactionValue\cf6 \strokec6 ,\cf2 \strokec2  server\cf6 \strokec6 );\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  compensation \cf6 \strokec6 =\cf2 \strokec2  compRemAmount\cf6 \strokec6 (\cf2 \strokec2 coverage\cf6 \strokec6 ,\cf2 \strokec2  transactionValue\cf6 \strokec6 );\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  balance \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 address\cf6 \strokec6 (\cf14 \strokec14 this\cf6 \strokec6 ).\cf2 \strokec2 balance\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  totalCompAmount \cf6 \strokec6 =\cf2 \strokec2  totalCompensasionAmount\cf6 \strokec6 ();\cf2 \strokec2 \
        \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 balance \cf6 \strokec6 +\cf2 \strokec2  premium \cf6 \strokec6 <\cf2 \strokec2  compensation \cf6 \strokec6 +\cf2 \strokec2  totalCompAmount\cf6 \strokec6 )\{\cf2 \strokec2 \
            res \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf13 \strokec13 return\cf2 \strokec2  res\cf6 \strokec6 ;\cf2 \strokec2   \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // Returns the amount amount_ to the caller, if it has previousely transferred that amount and it is within the refund time, delta. \cf2 \strokec2 \
    \cf5 \strokec5 function\cf2 \strokec2  withdraw\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  amount_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  continu \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 >\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Invalid request"\cf6 \strokec6 );\cf2 \strokec2  \cf4 \strokec4 // Check if the caller/client (i.e., msg.sender) has previously transferred any amount \cf2 \strokec2 \
        \cf15 \strokec15 for\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  i \cf6 \strokec6 =\cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  i \cf6 \strokec6 <\cf2 \strokec2  transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 !\cf2 \strokec2 continu\cf6 \strokec6 ;\cf2 \strokec2  i\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 amount \cf6 \strokec6 ==\cf2 \strokec2  amount_\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2  \cf4 \strokec4 // Check the amount stated matches the amount transferred\cf2 \strokec2 \
                \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 delta \cf6 \strokec6 >\cf2 \strokec2  \cf10 \strokec10 block\cf6 \strokec6 .\cf2 \strokec2 timestamp \cf6 \strokec6 -\cf2 \strokec2  transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 timestamp\cf6 \strokec6 )\{\cf2 \strokec2  \cf4 \strokec4 // Check if it's still within the valid time period for withdrawal\cf2 \strokec2 \
                    \cf8 \strokec8 payable\cf6 \strokec6 (\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ).\cf2 \strokec2 transfer\cf6 \strokec6 (\cf2 \strokec2 amount_\cf6 \strokec6 );\cf2 \strokec2 \
                    continu \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 ;\cf2 \strokec2  \
                    transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 amount \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2 \
                    transactions\cf6 \strokec6 [\cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 pending \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ;\cf2 \strokec2 \
                \cf6 \strokec6 \}\cf2 \strokec2 \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // It registers a result of verification of a client request. This function will successfully terminate only if it's called by a registered server (and must meet other conditions)\cf2 \strokec2 \
    \cf5 \strokec5 function\cf2 \strokec2  verRequest\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  client_address\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 bytes32\cf2 \strokec2  transactionId_\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 bool\cf2 \strokec2  val\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf5 \strokec5 bool\cf2 \strokec2  continu \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ;\cf2 \strokec2 \
        \cf15 \strokec15 for\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  i \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  i \cf6 \strokec6 <\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 !\cf2 \strokec2 continu\cf6 \strokec6 ;\cf2 \strokec2  i\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            \cf4 \strokec4 // Check if (1) the provided transaction ID is valid, (2) the caller of this function (i.e., msg.sender) has been (registered and) mentioned in the transaction as the interacting server, and (3) \cf2 \strokec2 \
            \cf4 \strokec4 // the related value for the verification of request has not already been set.  \cf2 \strokec2 \
            \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 transactionId \cf6 \strokec6 ==\cf2 \strokec2  transactionId_\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 server \cf6 \strokec6 ==\cf2 \strokec2  \cf10 \strokec10 msg\cf6 \strokec6 .\cf2 \strokec2 sender\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 set_approved \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 approved_by_server \cf6 \strokec6 =\cf2 \strokec2  val\cf6 \strokec6 ;\cf2 \strokec2 \
                transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 set_approved \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 ;\cf2 \strokec2 \
                continu \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 ;\cf2 \strokec2 \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf4 \strokec4 // To transfer the amount from the smart contract to the server. We have inluded "client_address" as an argument to let anyone to call the function\cf2 \strokec2 \
    \cf5 \strokec5 function\cf2 \strokec2  transfer\cf6 \strokec6 (\cf5 \strokec5 address\cf2 \strokec2  client_address\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 bytes32\cf2 \strokec2  transactionId_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf10 \strokec10 require\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ].\cf2 \strokec2 length \cf6 \strokec6 >\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ,\cf2 \strokec2  \cf11 \strokec11 "Invalid request"\cf6 \strokec6 );\cf2 \strokec2  \cf4 \strokec4 // Check if the caller/client (i.e., msg.sender) has previously transferred any amount \cf2 \strokec2 \
        \cf15 \strokec15 for\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  i \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  i \cf6 \strokec6 <\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ].\cf2 \strokec2 length\cf6 \strokec6 ;\cf2 \strokec2  i\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 amount \cf6 \strokec6 >\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  \
            \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 transactionId \cf6 \strokec6 ==\cf2 \strokec2  transactionId_\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  \
            \cf6 \strokec6 (\cf2 \strokec2 delta \cf6 \strokec6 <\cf2 \strokec2  \cf10 \strokec10 block\cf6 \strokec6 .\cf2 \strokec2 timestamp \cf6 \strokec6 -\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 timestamp\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                \cf4 \strokec4 // Refund the client if the server did not approve the client's request (and the server has already provided its response)\cf2 \strokec2 \
                \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 approved_by_server \cf6 \strokec6 ==\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 set_approved \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                    \cf8 \strokec8 payable\cf6 \strokec6 (\cf2 \strokec2 client_address\cf6 \strokec6 ).\cf2 \strokec2 transfer\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 amount\cf6 \strokec6 );\cf2 \strokec2 \
                    transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 amount \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2 \
                    transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 pending \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ;\cf2 \strokec2 \
                \cf6 \strokec6 \}\cf2 \strokec2 \
                \cf4 \strokec4 // Trasnfer the req amount to the server and refund the client if the client paid extra (and if the server has approved client's request)\cf2 \strokec2 \
                \cf12 \strokec12 else\cf2 \strokec2  \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 approved_by_server \cf6 \strokec6 ==\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  \
                \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 set_approved \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2 \
                \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 transferred \cf6 \strokec6 ==\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                    \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 amount \cf6 \strokec6 >=\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 premium \cf6 \strokec6 +\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 req\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                        \cf8 \strokec8 payable\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 server\cf6 \strokec6 ).\cf2 \strokec2 transfer\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 req\cf6 \strokec6 );\cf2 \strokec2  \cf4 \strokec4 // Transfer the amount to the server\cf2 \strokec2 \
                        transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 transferred \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 ;\cf2 \strokec2  \
                        \cf4 \strokec4 // Refund the client if it paid extra\cf2 \strokec2 \
                        \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 amount \cf6 \strokec6 >\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 premium \cf6 \strokec6 +\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 req\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
                            \cf5 \strokec5 uint\cf2 \strokec2  refund_amount_to_client \cf6 \strokec6 =\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 amount \cf6 \strokec6 -\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 premium \cf6 \strokec6 -\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 req\cf6 \strokec6 ;\cf2 \strokec2 \
                            \cf8 \strokec8 payable\cf6 \strokec6 (\cf2 \strokec2 client_address\cf6 \strokec6 ).\cf2 \strokec2 transfer\cf6 \strokec6 (\cf2 \strokec2 refund_amount_to_client\cf6 \strokec6 );\cf2 \strokec2  \
                        \cf6 \strokec6 \}\cf2 \strokec2 \
                    \cf6 \strokec6 \}\cf2 \strokec2 \
                \cf6 \strokec6 \}\cf2 \strokec2 \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\
    \cf5 \strokec5 function\cf2 \strokec2  reimburse\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  vote\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 address\cf2 \strokec2  client_address\cf6 \strokec6 ,\cf2 \strokec2  \cf5 \strokec5 bytes32\cf2 \strokec2  transactionId_\cf6 \strokec6 )\cf2 \strokec2  \cf8 \strokec8 public\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
        \cf5 \strokec5 uint256\cf2 \strokec2  final_verdict\cf6 \strokec6 ;\cf2 \strokec2 \
        castVote\cf6 \strokec6 (\cf2 \strokec2 vote\cf6 \strokec6 ,\cf2 \strokec2  client_address\cf6 \strokec6 ,\cf2 \strokec2  transactionId_\cf6 \strokec6 );\cf2 \strokec2  \cf4 \strokec4 // Cast each vote\cf2 \strokec2 \
        \cf15 \strokec15 for\cf6 \strokec6 (\cf5 \strokec5 uint256\cf2 \strokec2  i \cf6 \strokec6 =\cf2 \strokec2  \cf7 \strokec7 0\cf6 \strokec6 ;\cf2 \strokec2  i \cf6 \strokec6 <\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ].\cf2 \strokec2 length\cf6 \strokec6 ;\cf2 \strokec2  i\cf6 \strokec6 ++)\cf2 \strokec2  \cf6 \strokec6 \{\cf2 \strokec2 \
            \cf4 \strokec4 // Each time an auditor votes, check if the total number of auditors voted for this specific transaction\cf2 \strokec2 \
            \cf4 \strokec4 // reached the predefined threshold:min_number_of_auditors\cf2 \strokec2 \
            \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 auditors_counter \cf6 \strokec6 >=\cf2 \strokec2  min_number_of_auditors\cf6 \strokec6 )\{\cf2 \strokec2 \
                final_verdict \cf6 \strokec6 =\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 votes\cf6 \strokec6 ;\cf2 \strokec2 \
                \cf5 \strokec5 uint256\cf2 \strokec2  temp \cf6 \strokec6 =\cf2 \strokec2  extractVerdict\cf6 \strokec6 (\cf2 \strokec2 client_address\cf6 \strokec6 ,\cf2 \strokec2  i\cf6 \strokec6 );\cf2 \strokec2 \
                \cf12 \strokec12 if\cf6 \strokec6 (\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 temp \cf6 \strokec6 ==\cf2 \strokec2  \cf7 \strokec7 1\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 &&\cf2 \strokec2  \cf6 \strokec6 (\cf2 \strokec2 transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 pending \cf6 \strokec6 ==\cf2 \strokec2  \cf5 \strokec5 true\cf6 \strokec6 )\cf2 \strokec2  \cf6 \strokec6 )\{\cf2 \strokec2 \
                    \cf5 \strokec5 uint256\cf2 \strokec2  amount \cf6 \strokec6 =\cf2 \strokec2  compRemAmount\cf6 \strokec6 (\cf2 \strokec2 coverage\cf6 \strokec6 ,\cf2 \strokec2  transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 req\cf6 \strokec6 );\cf2 \strokec2 \
                    transactions\cf6 \strokec6 [\cf2 \strokec2 client_address\cf6 \strokec6 ][\cf2 \strokec2 i\cf6 \strokec6 ].\cf2 \strokec2 pending \cf6 \strokec6 =\cf2 \strokec2  \cf5 \strokec5 false\cf6 \strokec6 ;\cf2 \strokec2 \
                    \cf8 \strokec8 payable\cf6 \strokec6 (\cf2 \strokec2 client_address\cf6 \strokec6 ).\cf2 \strokec2 transfer\cf6 \strokec6 (\cf2 \strokec2 amount\cf6 \strokec6 );\cf2 \strokec2 \
                \cf6 \strokec6 \}\cf2 \strokec2 \
            \cf6 \strokec6 \}\cf2 \strokec2 \
        \cf6 \strokec6 \}\cf2 \strokec2 \
    \cf6 \strokec6 \}\cf2 \strokec2 \
\pard\pardeftab720\partightenfactor0
\cf6 \strokec6 \}\cf2 \strokec2 \
\
\
\
\
}