# 이더리움 네트워크 구축

docker와 parity를 이용하여 이더리움 네트워크 구축하기

## 미리 생성된 계정

```
address: 0x09d6bf913971d78f3e0347b5feb2b517c78ee0b9, password: p
address: 0xbfb2ef766b9f8688313ff27bd5dd12b7d01efedd, password: p
address: 0x7a17f31b04c3e4bbd2ae086dd93f53d557654d97, password: p
address: 0x123be6131dbd0a767b9a2343c251bc4718d3bcae, password: p
```

## 1. 이미지 빌드 / 컨테이너 생성

### 이미지 생성

```bash
$ docker build --tag ethereum_parity:0.1 .
```


### 노드 생성

```bash
$ docker-compose up -d
```


### 노드 제거

```bash
$ docker-compose down
```

## 2. 각 노드 설정 변경

### 노드 컨테이너 접속방법

```bash
$ docker exec -it node1.ethereum.com /bin/bash  # 1번 노드 접속
$ docker exec -it node2.ethereum.com /bin/bash # 2번 노드 접속
$ docker exec -it node3.ethereum.com /bin/bash # 3번 노드 접속
```

### enode 정보 얻기

```bash
$ chmod 777 start.sh
$ ./start.sh
Loading config file from /home/blockchain/node.toml
2018-12-13 03:13:38 UTC Starting Parity-Ethereum/v2.2.4-beta-f44d885-20181205/x86_64-linux-gnu/rustc1.30.1
2018-12-13 03:13:38 UTC Keys path ./DATA_STORE/keys/testNetwork
2018-12-13 03:13:38 UTC DB path ./DATA_STORE/chains/testNetwork/db/291e119b237a5e05
2018-12-13 03:13:38 UTC State DB configuration: fast
2018-12-13 03:13:38 UTC Operating mode: active
2018-12-13 03:13:38 UTC Configured for testNetwork using AuthorityRound engine
2018-12-13 03:13:43 UTC Public node URL: enode://1e3e8f6c474bab5bc9bddabdc51f34cf0939db754dfcd02c5a09dce9e3e28d9f6919caa00e6d9c37a22bb5da8cb115344b38c111a7d63fa02fc9ad7d4096dff5@172.18.0.4:30303
```

`enode://1e3e8f6c474bab5bc9bddabdc51f34cf0939db754dfcd02c5a09dce9e3e28d9f6919caa00e6d9c37a22bb5da8cb115344b38c111a7d63fa02fc9ad7d4096dff5@172.18.0.4:30303`을 복사해둔다.

`ctrl + c`를 눌러 해당 프로세스를 종료.

3개의 노드에서 똑같이 작업하여 `enode`를 추출

@ip:port는 해당 환경에 맞춰서 변경

예를 들어 다음과 같이 `enode`들을 얻고 `IP`와 `PORT`를 해당 환경에 맞춰서 설정합니다.

```
1번노드  =>  enode://1e3e8f6c474bab5bc9bddabdc51f34cf0939db754dfcd02c5a09dce9e3e28d9f6919caa00e6d9c37a22bb5da8cb115344b38c111a7d63fa02fc9ad7d4096dff5@127.0.0.1:30303
2번노드  =>  enode://23c143a93d14c967ac885f0eb185533c3b5aa5407855a956b4f52953b26d188a1e12443cbb368bdaa13bb96b418672a49854964ad2838769ed6bc777b497f2bd@127.0.0.1:30304
3번노드  =>  enode://ff412e5d0005cfd0395d369c0aff04ea8c3ceabcfd7162c0270491302066f963ebd05000019c24927ec07d291c6c95a5bef8030ab19d207c55f31f1da65fd2df@127.0.0.1:30305
```

> 참고: 아래 내용은 각 노드에 들어가서 원하는 형태로 설정해야 하는 부분입니다.

### 피어연결 설정

```
$ vim nodes
```

각 노드 컨테이너에서 `/home/blockchain/nodes`를 열어 enode 정보를 넣어줍니다. 노드를 실행하면, 해당 `nodes`에 명시된 enode로 연결을 시도합니다.

```
enode://23c143a93d14c967ac885f0eb185533c3b5aa5407855a956b4f52953b26d188a1e12443cbb368bdaa13bb96b418672a49854964ad2838769ed6bc777b497f2bd@127.0.0.1:30304
enode://ff412e5d0005cfd0395d369c0aff04ea8c3ceabcfd7162c0270491302066f963ebd05000019c24927ec07d291c6c95a5bef8030ab19d207c55f31f1da65fd2df@127.0.0.1:30305
```

예를 들어 1번 노드가 2번, 3번 노드와 연결하고 싶으면 앞의 예시처럼 명시해주면 됩니다.

### 마이너 설정

```
$ vim node.toml
```

```toml
[parity]
chain = "chain.json" # chain 정보
base_path = "./DATA_STORE" # 정보를 어디에 저장할 지
[network]
port = 30303
reserved_peers=  "./nodes" # 연결될 피어정보
warp = true
allow_ips = "all"
snapshot_peers = 0
max_pending_peers = 64
[rpc]
port = 8545
apis = ["web3", "eth", "net", "personal", "parity", "parity_set", "traces" ,"rpc", "parity_accounts"]
[ui]
port = 8180
[websockets]
port = 8455
[account]
password = ["node.pwds"]
[mining]
#engine_signer = "0x09d6bf913971d78f3e0347b5feb2b517c78ee0b9" # 마이닝 account POA 이기 때문에 chain.json에서 validator에 명시된 account를 넣는다. 마이닝을 하지 않는 노드라면 해당 부분 #으로 주석처리
reseal_on_txs = "none"
[dapps]
disable = false
[ipc]
disable = false
apis = ["web3", "eth", "net", "personal", "parity", "parity_set", "traces" ,"rpc", "parity_accounts"]
```

`engine_signer`가 블록 생성자를 명시하는 부분입니다. `#` 주석을 지우고 `chain.json`에서 `validators`에 등록된 게정중 아무거나 넣어주면 됩니다.

### 노드 시작

```bash
$ ./start.sh
```