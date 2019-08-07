# hamonikr-secure-chain

배포되는 하모니카OS가 아닌 다른 운영체제로 부팅을 방지하는 프로그램

* 하모니카 디지털 사인을 검증하여 인가되지 않은 운영체제의 부팅을 방지
* UEFI 모드의 부팅환경에서만 사용 가능
* 관련 기술문서 : https://pms.invesume.com:8444/display/A1/UEFI+Secure+Boot

# License

* GPL v3

# Download

```
git clone ssh://git@pms.invesume.com:7999/hos/hamonikr-secure-chain.git
cd hamonikr-secure-chain
```

# Usage 

## Create RSA key pair for HamoniKR
```./hamonikr-secure-chain.sh create-key```

## Apply Secure Chain for HamoniKR

```./hamonikr-secure-chain.sh update-chain```

## Verify Secure Chain Sigining Files for HamoniKR
```./hamonikr-secure-chain.sh verify```
