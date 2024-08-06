package com.dolharubang.domain.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Members {

    @Id
    private String memberEmail;

    private String nickname;

    private String birthday;

    private String refreshToken;

    private String provider;

    private Long sands;

    private LocalDateTime createdAt;

    private LocalDateTime lastLoginAt;

    private LocalDateTime modifiedAt;

    private Long totalLoginDays;

    private String profilePicture;

    private String spaceName;

    @Builder
    public Members(String memberEmail, String nickname, String birthday, String refreshToken,
        String provider, Long sands, LocalDateTime createdAt, LocalDateTime lastLoginAt,
        LocalDateTime modifiedAt, Long totalLoginDays, String profilePicture, String spaceName) {
        this.memberEmail = memberEmail;
        this.nickname = nickname;
        this.birthday = birthday;
        this.refreshToken = refreshToken;
        this.provider = provider;
        this.sands = sands;
        this.createdAt = createdAt;
        this.lastLoginAt = lastLoginAt;
        this.modifiedAt = modifiedAt;
        this.totalLoginDays = totalLoginDays;
        this.profilePicture = profilePicture;
        this.spaceName = spaceName;
    }

    //Refresh Token 갱신
    public void updateRefreshToken(String updateRefreshToken) {
        this.refreshToken = updateRefreshToken;
    }

    //로그인 일수 증가
    public void incrementTotalLoginDays(Long totalLoginDays) {
        this.totalLoginDays  = totalLoginDays + 1;
    }

    // 마지막 로그인 시간 업데이트
    public void updateLastLoginAt() {
        this.lastLoginAt = LocalDateTime.now();
    }

    public void update(String nickname, Long sands, String profilePicture, String spaceName) {
        this.nickname = nickname;
        this.sands = sands;
        this.profilePicture = profilePicture;
        this.spaceName = spaceName;
        this.modifiedAt = LocalDateTime.now();
    }

    //엔티티가 영속성 컨텍스트에 저장되기 전에 호출
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.lastLoginAt = LocalDateTime.now();
        this.modifiedAt = LocalDateTime.now();
    }

    //엔티티가 영속성 컨텍스트에 업데이트되기 전에 호출
    @PreUpdate
    protected void onUpdate() {
        this.modifiedAt = LocalDateTime.now();
    }
}
