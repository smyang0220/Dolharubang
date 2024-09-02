package com.dolharubang.service;

import com.dolharubang.domain.dto.request.DiaryReqDto;
import com.dolharubang.domain.dto.response.DiaryResDto;
import com.dolharubang.domain.entity.Diary;
import com.dolharubang.domain.entity.Member;
import com.dolharubang.exception.CustomException;
import com.dolharubang.exception.ErrorCode;
import com.dolharubang.repository.DiaryRepository;
import com.dolharubang.repository.MemberRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class DiaryService {

    private final DiaryRepository diaryRepository;
    private final MemberRepository memberRepository;

    public DiaryService(DiaryRepository diaryRepository, MemberRepository memberRepository) {
        this.diaryRepository = diaryRepository;
        this.memberRepository = memberRepository;
    }

    @Transactional
    public DiaryResDto createDiary(DiaryReqDto diaryReqDto) {
        Member member = memberRepository.findById(diaryReqDto.getMemberId())
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        Diary diary = Diary.builder()
            .member(member)
            .contents(diaryReqDto.getContents())
            .emoji(diaryReqDto.getEmoji())
            .image(diaryReqDto.getImage())
            .reply(diaryReqDto.getReply())
            .build();

        Diary savedDiary = diaryRepository.save(diary);
        return DiaryResDto.fromEntity(savedDiary);
    }

    //TODO RUD 메서드 생성

//    @Transactional
//    public DiaryResDto updateDiary(Long id, DiaryReqDto diaryReqDto) {
//        Diary diary = diaryRepository.findByDiaryId(id)
//            .orElseThrow(() -> new CustomException(ErrorCode.DIARY_NOT_FOUND));
//
//        Member member = memberRepository.findByMemberId(diaryReqDto.getMemberId())
//            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));
//    }
}
