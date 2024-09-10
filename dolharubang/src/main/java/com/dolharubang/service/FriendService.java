package com.dolharubang.service;

import com.dolharubang.domain.dto.request.FriendReqDto;
import com.dolharubang.domain.dto.response.FriendResDto;
import com.dolharubang.domain.entity.Friend;
import com.dolharubang.domain.entity.Member;
import com.dolharubang.exception.CustomException;
import com.dolharubang.exception.ErrorCode;
import com.dolharubang.repository.FriendRepository;
import com.dolharubang.repository.MemberRepository;
import com.dolharubang.type.FriendStatusType;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class FriendService {

    private final FriendRepository friendRepository;
    private final MemberRepository memberRepository;

    // 친구 목록 조회 (ACCEPTED 상태)
    public List<FriendResDto> getAcceptedFriendList(Long memberId) {
        Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        List<Friend> friends = friendRepository.findAllFriendsByStatus(member,
            FriendStatusType.ACCEPTED);

        return friends.stream()
            .map(FriendResDto::fromEntity)
            .collect(Collectors.toList());
    }

    // 내가 보낸 친구 요청 목록 조회 (requester가 PENDING 상태인 경우)
    public List<FriendResDto> getSentFriendRequests(Long memberId) {
        Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        // 내가 요청을 보낸 PENDING 상태의 요청들 조회
        List<Friend> sentRequests = friendRepository.findAllSentFriendRequests(member,
            FriendStatusType.PENDING);

        return sentRequests.stream()
            .map(FriendResDto::fromEntity)
            .collect(Collectors.toList());
    }

    // 내가 받은 친구 요청 목록 조회 (receiver가 PENDING 상태인 경우)
    public List<FriendResDto> getReceivedFriendRequests(Long memberId) {
        Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        // 내가 받은 PENDING 상태의 요청들 조회
        List<Friend> receivedRequests = friendRepository.findAllReceivedFriendRequests(member,
            FriendStatusType.PENDING);

        return receivedRequests.stream()
            .map(FriendResDto::fromEntity)
            .collect(Collectors.toList());
    }

    // 친구 요청 보내기
    public FriendResDto sendFriendRequest(FriendReqDto friendReqDto) {
        Member requester = memberRepository.findById(friendReqDto.getRequesterId())
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));
        Member receiver = memberRepository.findById(friendReqDto.getReceiverId())
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        // 요청자와 수신자의 관계를 양방향으로 조회 (소프트 딜리트 포함)
        Friend friendRequest = friendRepository.findBetweenMembersWithDeleted(requester, receiver);

        if (friendRequest != null) {
            // 이미 ACCEPTED 상태라면 새로운 친구 요청을 허용하지 않음
            if (friendRequest.getStatus() == FriendStatusType.ACCEPTED) {
                throw new CustomException(ErrorCode.FRIEND_ALREADY_ACCEPTED);
            }

            // 요청자가 동일한 상태로 이미 PENDING 요청을 보냈다면 에러 반환
            if (friendRequest.getStatus() == FriendStatusType.PENDING
                && friendRequest.getRequester().equals(requester)) {
                throw new CustomException(ErrorCode.FRIEND_ALREADY_PENDING);
            }

            // 상대방이 이미 요청을 보낸 상태라면 수락으로 처리 (요청자와 수신자가 바뀌었을 때)
            if (friendRequest.getStatus() == FriendStatusType.PENDING
                && !friendRequest.getRequester().equals(requester)) {
                friendRequest.accept();  // 수락 처리
                friendRepository.save(friendRequest);
                return FriendResDto.fromEntity(friendRequest);  // 친구 관계 수락 후 반환
            }

            // 소프트 딜리트 또는 거절된 경우에는 새로운 요청으로 처리
            if (friendRequest.getStatus() == FriendStatusType.DECLINED
                || friendRequest.getStatus() == FriendStatusType.DELETED) {
                friendRequest.restore(requester, receiver);  // 상태를 PENDING으로 변경
                friendRepository.save(friendRequest);
                return FriendResDto.fromEntity(friendRequest);
            }
        }

        // 새로운 친구 요청 생성
        Friend newFriendRequest = Friend.builder()
            .requester(requester)
            .receiver(receiver)
            .status(FriendStatusType.PENDING)  // 기본 상태는 PENDING
            .build();

        Friend savedRequest = friendRepository.save(newFriendRequest);
        return FriendResDto.fromEntity(savedRequest);
    }


    // 친구 요청 수락
    public FriendResDto acceptFriendRequest(Long requesterId, Long receiverId) {
        Member requester = memberRepository.findById(requesterId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));
        Member receiver = memberRepository.findById(receiverId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        // 요청자와 수신자의 관계를 조회 (양방향으로 조회)
        Friend friendRequest = friendRepository.findBetweenMembersWithDeleted(requester, receiver);

        // 요청이 없거나 삭제된 상태라면 친구 요청을 찾을 수 없는 에러 던짐
        if (friendRequest == null || friendRequest.getStatus() == FriendStatusType.DELETED) {
            throw new CustomException(ErrorCode.FRIEND_NOT_FOUND);
        }

        // 요청이 거절된 상태라면 해당 요청은 이미 거절 됐다는 에러 던짐
        if (friendRequest.getStatus() == FriendStatusType.DECLINED) {
            throw new CustomException(ErrorCode.FRIEND_ALREADY_DECLINED);
        }

        // 요청이 수락된 상태라면 해당 요청은 이미 수락 됐다는 에러 던짐
        if (friendRequest.getStatus() == FriendStatusType.ACCEPTED) {
            throw new CustomException(ErrorCode.FRIEND_ALREADY_ACCEPTED);
        }

        friendRequest.accept();
        friendRepository.save(friendRequest);

        return FriendResDto.fromEntity(friendRequest);
    }

    // 친구 요청 거절
    public FriendResDto declineFriendRequest(Long requesterId, Long receiverId) {
        Member requester = memberRepository.findById(requesterId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));
        Member receiver = memberRepository.findById(receiverId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        // 요청자와 수신자의 관계를 조회 (양방향으로 조회)
        Friend friendRequest = friendRepository.findBetweenMembersWithDeleted(requester, receiver);

        // 요청이 없거나 삭제된 상태라면 친구 요청을 찾을 수 없는 에러 던짐
        if (friendRequest == null || friendRequest.getStatus() == FriendStatusType.DELETED) {
            throw new CustomException(ErrorCode.FRIEND_NOT_FOUND);
        }

        // 요청이 이미 수락된 상태라면 해당 요청은 이미 수락 됐다는 에러 던짐
        if (friendRequest.getStatus() == FriendStatusType.ACCEPTED) {
            throw new CustomException(ErrorCode.FRIEND_ALREADY_ACCEPTED);
        }

        // 요청이 거절된 상태라면 해당 요청은 이미 거절 됐다는 에러 던짐
        if (friendRequest.getStatus() == FriendStatusType.DECLINED) {
            throw new CustomException(ErrorCode.FRIEND_ALREADY_DECLINED);
        }

        friendRequest.decline();
        friendRepository.save(friendRequest);

        return FriendResDto.fromEntity(friendRequest);
    }

    // 친구 삭제 (친구 관계 종료)
    public FriendResDto deleteFriend(Long memberId, Long friendId) {
        Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));
        Member friend = memberRepository.findById(friendId)
            .orElseThrow(() -> new CustomException(ErrorCode.MEMBER_NOT_FOUND));

        // 요청자와 수신자의 관계를 조회 (양방향으로 조회)
        Friend friendRequest = friendRepository.findBetweenMembersWithDeleted(member, friend);

        if (friendRequest == null || friendRequest.getStatus() != FriendStatusType.ACCEPTED) {
            throw new CustomException(ErrorCode.FRIEND_CANNOT_BE_DELETED);
        }

        // 관계를 삭제 (소프트 딜리트 처리)
        friendRequest.delete();
        friendRepository.save(friendRequest);

        return FriendResDto.fromEntity(friendRequest);
    }
}
