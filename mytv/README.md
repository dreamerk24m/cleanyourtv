# 내 TV: TCL 55C755 (한국)

2026년 10월 24일에 정리한 기록입니다. 이 폴더는 `my-tv` 브랜치에만 있습니다.

| 항목 | 값 |
|---|---|
| 모델 | TCL 55C755 (Smart TV Pro), 한국 판매 |
| 보드 | G08 (`G08_4K_GB`), MediaTek `tcl9618`, RAM 약 2.4 GB |
| OS | Google TV, Android 14 (SDK 34) |
| 펌웨어 | `UTT2.250416.001 AU02`, 보안 패치 2025-12-05 |
| 참고 목록 | [`examples/tcl-c755-google-tv`](../examples/tcl-c755-google-tv/debloat.txt) (호주판, 같은 펌웨어) |

아래 명령은 모두 레포 폴더(`cleanyourtv`)에서 실행합니다. `<tv ip>`에는 TV 주소를 넣으세요
(TV 설정 → 네트워크 및 인터넷).

## 바꾼 것

**앱 비활성화** (삭제 아님). 묶음별 이유는 각 파일에 있습니다.

| 파일 | 내용 |
|---|---|
| [batch-1.txt](batch-1.txt) | TCL 추적·분석 (`ttvs`: Samba TV 시청 추적, TCL 분석, T-Cast, TCL 펌웨어 업데이트) |
| [batch-2.txt](batch-2.txt) | TCL 광고·추천 (Channel+, 홈 광고 줄, 푸시 메시지) |
| [batch-3.txt](batch-3.txt) | 매장 데모·호텔 모드 |
| [batch-4.txt](batch-4.txt) | 기본 탑재 앱 (Alexa, 청소 앱, 파트너 앱 자동 설치, Prime Video, YouTube Music 등) |
| [batch-5.txt](batch-5.txt) | USB 미디어 플레이어, USB 갤러리, TCL 사운드바 업데이트 |
| [batch-6.txt](batch-6.txt) | Google TV 설정 마법사 (`setupwraith`) |
| [batch-7.txt](batch-7.txt) | Google 광고 화면보호기 (`dreamx`) |

묶음 파일에 든 패키지는 29개이고, 런처 설치 스크립트가 **Google TV 홈**(`com.google.android.apps.tv.launcherx`)을
하나 더 껐습니다. `pm list packages -d`에는 29개가 나옵니다: 묶음 4의 Google TV(영화) 앱은 주 사용자에게
설치되어 있지 않아 목록에 나오지 않습니다.

**켜 둔 것**: YouTube, Netflix, Google 어시스턴트(마이크), Chromecast, AirPlay, Miracast, 게임바,
HDMI·입력 전환(`com.tcl.tv`, `com.tcl.tvinput`, `com.tcl.suspension`), TCL 대시보드, 혼자 듣기(`t_solo`),
Play 스토어와 Play 서비스, 직접 설치한 앱(쿠팡플레이, MX Player, Nova, CX 파일 탐색기).

**런처**: `launcher/`의 런처를 한국어로 빌드해 홈으로 설정했습니다. 설정은
[`config.xml`](../launcher/app/src/main/res/values/config.xml)에 있습니다.

- 독: YouTube → Netflix → 쿠팡플레이 → Nova (4칸)
- 숨긴 아이콘: TV 플레이어(`com.tcl.tv`), TCL 대시보드(`com.tcl.dashboard`), 화면 미러링(T-Cast,
  `com.tcl.magiconnectfree`), Quick panel(`com.tcl.suspension`). 앱은 켜져 있어서 리모컨 버튼과
  상단 입력 메뉴로는 그대로 열립니다.
- 앱 목록 맨 끝에 **런처 설정** 타일 (`launcher_settings_tile`, 이 브랜치에만 있는 기능). 설정 버튼을
  길게 눌러 여는 메뉴의 "런처 설정"도 그대로 있습니다.
- 입력 메뉴의 "실시간 TV" 줄 없음 (안테나 미연결)
- 리모컨: 톱니바퀴(83) → 설정 패널, YouTube(190), Netflix(4062) → 각 앱 (키 도우미 `HomeKeyService`)
- 화면보호기: 런처 시계(`com.gathin.tvhome/.ClockDream`)

**배경화면**: 오로라 사진 테마 [`theme-aurora`](theme-aurora/config.json) (아래 "독 순서, 아이콘, 배경화면 바꾸기" 참고).

**비공개 DNS**: `dns.adguard-dns.com` (광고·추적 도메인 차단, YouTube 광고는 못 막음).

재부팅 후에도 꺼진 앱이 다시 켜지지 않는 것을 확인했습니다.

## 런처 다시 설치하기

```sh
git switch my-tv
TV_HOST=<tv ip> mytv/build-and-install.sh
```

JDK 17과 Android SDK 34가 필요합니다. 이 스크립트는 키 도우미(`HOME_KEY_SERVICE=1`)를 함께 켭니다.
`launcher/build-and-install.sh`를 직접 실행하면 키 도우미가 빠져서 톱니바퀴·YouTube·Netflix 버튼이
다시 안 됩니다.

## 앱 하나만 다시 켜기

TV에서: **설정 → 앱 → 모든 앱 보기 → 시스템 앱 표시** → 앱 선택 → **사용**.

또는 Mac에서 (예: Prime Video):

```sh
TV_HOST=<tv ip> tools/venv/bin/python -I tools/tv.py 'pm enable com.amazon.amazonvideo.livingroom'
```

그다음 해당 묶음 파일에서 그 줄 앞에 `#`을 붙여 두면, 목록을 다시 적용해도 꺼지지 않습니다.

`launcherx`와 `setupwraith`는 새 런처가 홈인 동안 켜지 마세요. 둘 다 홈을 다시 가져갑니다.
되돌리려면 아래 "전부 되돌리기"를 쓰세요.

TCL 펌웨어 업데이트를 확인할 때는 `com.tcl.ttvs`를 잠깐 켰다가(`pm enable com.tcl.ttvs`), 업데이트 후
다시 끕니다(`pm disable-user --user 0 com.tcl.ttvs`).

## 독 순서, 아이콘, 배경화면 바꾸기

**TV에서 바로**: 앱 목록 맨 끝의 **런처 설정** 타일을 누르거나, 홈 오른쪽 위 **설정** 버튼에
포커스를 두고 **OK를 길게** 누르면 메뉴가 열립니다.

- **독 편집**: 독의 자리를 고른 뒤 넣을 앱을 고릅니다.
- **앱 순서 바꾸기**: 격자 앱의 순서를 옮깁니다.
- **런처 설정**: 한 줄당 앱 수, 독 아래 줄 수, 독 배경 불투명도, 배경화면, 애니메이션.

TV에서 바꾼 값은 `config.xml`보다 우선합니다. 런처 설정의 "테마에 맞추기"를 고르면 `config.xml` 값으로
돌아갑니다.

**`config.xml`로**: `dock_apps`(독 순서), `hidden_apps`(숨길 앱), `columns`(4~7칸),
`launcher_settings_tile`(런처 설정 타일 표시 여부)을 고친 뒤
위의 "런처 다시 설치하기"를 실행하고 `my-tv` 브랜치에 커밋합니다. 패키지 이름은
`tools/tv.py 'pm list packages'`로 확인합니다.

**배경화면**: `themes/` 폴더의 테마를 보내거나(`tools/theme.sh themes/aurora`), 직접 만든 테마 폴더에
`config.json`과 `wallpaper.jpg`를 넣어 보냅니다. 키 목록은 [`themes/README.md`](../themes/README.md)에 있습니다.

```sh
TV_HOST=<tv ip> tools/theme.sh themes/aurora
TV_HOST=<tv ip> tools/theme.sh --reset    # 테마 지우고 config.xml로 돌아가기
```

### 지금 쓰는 테마: `mytv/theme-aurora`

오로라 사진 배경입니다. [`config.json`](theme-aurora/config.json)은 레포의 `themes/aurora`와 같고,
`wallpaper_true_color`만 더했습니다. 이 설정이 없으면 배경을 16비트 색으로 그려서 어두운 하늘에 띠가
생깁니다(이 TV는 RAM 약 2.4 GB라 32비트로 그려도 됩니다).

`wallpaper.jpg`는 저작권 때문에 **커밋하지 않고 이 Mac에만** 둡니다(`.git/info/exclude`). 다른 컴퓨터에서
클론하면 사진이 없으니, 사진을 다시 넣고 보내야 합니다.

- 사진 만들기: 원본을 가로 1920으로 줄인 뒤 **위쪽 1080줄만** 남깁니다(아래만 잘라냄). JPEG 품질 90 안팎,
  1920×1080. 해상도는 최대 4K까지 받지만 화면은 1920×1080으로 그려지므로 그 이상은 이득이 없습니다.
- 적용: `TV_HOST=<tv ip> tools/theme.sh mytv/theme-aurora`
- 포커스된 앱 색이 배경에 번지는 효과를 끄려면 `config.json`에 `"ambient_glow": false`를 넣습니다.

테마를 보내면 런처 설정에서 TV로 바꾼 값(칸 수, 애니메이션)은 초기화됩니다. 키 도우미는 `theme.sh`가
다시 켜 줍니다.

## 키 도우미와 볼륨

톱니바퀴·YouTube·Netflix 버튼은 원래 Google TV 홈이 처리했습니다. 그 홈을 껐기 때문에 런처의 키 도우미
(TV 설정 → 접근성 → **홈 버튼**)가 대신 처리합니다.

이 펌웨어에서는 키를 가로채는 접근성 서비스가 켜져 있으면 **볼륨을 길게 눌러도 한 칸씩만** 움직일 수
있습니다([설명](../docs/devices/tcl-55p71b-g09-key-repeat.md)). 버튼과 볼륨 연속 조절은 동시에 가질 수
없습니다. 볼륨 연속 조절이 필요하면 키 도우미를 끕니다(버튼은 다시 안 됨):

```sh
TV_HOST=<tv ip> tools/venv/bin/python -I tools/tv.py "settings put secure enabled_accessibility_services ''; settings put secure accessibility_enabled 0"
```

다시 켜려면 `mytv/build-and-install.sh`를 실행합니다. 런처를 강제 종료해도 키 도우미가 꺼지니,
그때는 TV 설정 → 접근성에서 **홈 버튼**을 다시 켭니다.

## 광고 차단 DNS 되돌리기

```sh
TV_HOST=<tv ip> tools/venv/bin/python -I tools/tv.py 'settings put global private_dns_mode opportunistic'
```

## 전부 되돌리기

```sh
TV_HOST=<tv ip> mytv/restore-all.sh
```

키 도우미를 끄고, 묶음 7 → 1 순서로 `tools/restore.sh`를 실행해 꺼둔 앱과 Google TV 홈을 되살리고,
화면보호기와 DNS를 원래 값으로 돌립니다. 런처 앱은 설치된 채로 남습니다. 런처를 계속 쓰면서 배경 테마만
지우려면 `TV_HOST=<tv ip> tools/theme.sh --reset`을 씁니다.

`tools/restore.sh`는 `~/.cleanyourtv/`에 저장된 기록(끄기 전 상태)을 씁니다. 이 기록은 TV 주소별로
저장되므로, TV 주소가 바뀌면 기록을 못 찾고 "목록 전체 다시 켜기"로 대신합니다. 이 TV는 처음부터 꺼진
앱이 없었기 때문에 결과는 같습니다.

## 작업이 끝나면

네트워크 ADB(5555 포트)를 닫습니다. TV에서 **설정 → 시스템 → 개발자 옵션**의 USB 디버깅과 무선 디버깅을
끄고, **USB 디버깅 권한 취소**를 누른 뒤 재부팅합니다. 그다음 포트가 닫혔는지 확인합니다:

```sh
tools/venv/bin/python -I tools/adb-closed.py <tv ip>
```
