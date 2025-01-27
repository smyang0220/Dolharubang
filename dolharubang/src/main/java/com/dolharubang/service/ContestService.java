package com.dolharubang.service;

import com.dolharubang.domain.dto.request.ContestReqDto;
import com.dolharubang.domain.dto.response.ContestResDto;
import com.dolharubang.domain.entity.Contest;
import com.dolharubang.domain.entity.Member;
import com.dolharubang.exception.CustomException;
import com.dolharubang.exception.ErrorCode;
import com.dolharubang.repository.ContestRepository;
import com.dolharubang.repository.MemberRepository;
import com.dolharubang.s3.S3UploadService;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ContestService {

    private final ContestRepository contestRepository;
    private final MemberRepository memberRepository;
    private final S3UploadService s3UploadService;

    public ContestService(ContestRepository contestRepository, MemberRepository memberRepository,
        S3UploadService s3UploadService) {
        this.contestRepository = contestRepository;
        this.memberRepository = memberRepository;
        this.s3UploadService = s3UploadService;
    }

    @Transactional
    public ContestResDto createContest(Long memberId, ContestReqDto reqDto) {
        Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        Contest contest = Contest.builder()
            .member(member)
            .isPublic(reqDto.getIsPublic())
            .profileImgUrl(reqDto.getProfileImgUrl())
            .stoneName(reqDto.getStoneName())
            .build();

        Contest savedContest = contestRepository.save(contest);
        String imageUrl = s3UploadService.saveImage(reqDto.getProfileImgUrl(),
            "dolharubang/contest/",
            savedContest.getId());

        savedContest.updateImage(imageUrl);

        return ContestResDto.fromEntity(savedContest);
    }

    @Transactional(readOnly = true)
    public List<ContestResDto> getMyAllContestProfiles(Long memberId) {
        List<Contest> contest = contestRepository.findAllByMember(
            memberRepository.findById(memberId)
                .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND)));
        if (contest.isEmpty()) {
            throw new CustomException(ErrorCode.CONTEST_NOT_FOUND_BY_MEMBER);
        }
        return contest.stream()
            .map(ContestResDto::fromEntity)
            .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ContestResDto getContestProfile(Long memberId, Long contestId) {
        Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        Contest contest = contestRepository.findByIdAndMember(contestId, member)
            .orElseThrow(() -> new CustomException(ErrorCode.CONTEST_MEMBER_MISMATCH));

        return ContestResDto.fromEntity(contest);
    }

}
