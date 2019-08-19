# hamonikr-sb

Secure Boot Chain for HamoniKR

## 데비안 패키지 빌드

다운로드 받은 디렉토리 안에서 아래와 같이 빌드하면 release 폴더 안에 설치 가능한 데비안 파일 생성

```
./build
```

## 프로그램 설치

```
sudo dpkg -i release/hamonikr-sb*.deb
```

## 프로그램 실행

```
cd /usr/local/hamonikr-sb

하모니카 시큐어 체인 적용
sudo ./hamonikr-sb install

하모니카 시큐어 체인을 제거하고 이전 설정으로 복구
sudo ./hamonikr-sb restore
```


## 프로그램 삭제

```
sudo apt purge hamonikr-sb
```

## 버그 또는 이슈 제출

사용 중 발견한 버그나 이슈는 help@hamonikr.org 로 메일을 보내주세요

