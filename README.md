# AppStore_Search

## AppStore의 search 탭 구현
- King Fisher 쓰지 않고 image 로드 (cache, disk 메모리에 저장하는 방식 사용)
- 최근 검색어 UserDefaults에 저장
- 검색어 자동 완성 list 추가
- 앱 평점 소수점 셋째 자리에서 반올림하여 별 색칠 (3.3점 -> 별 3개 + 0.3개 색칠)
