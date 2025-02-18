package com.dolharubang.domain.entity;

import com.dolharubang.exception.CustomException;
import com.dolharubang.exception.ErrorCode;
import com.dolharubang.type.AbilityType;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapKeyEnumerated;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import java.time.LocalDateTime;
import java.util.Map;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Entity
@Getter
public class Stone extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long stoneId;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    private Long speciesId;

    private String stoneName;

    private Long closeness;

    @ElementCollection
    @CollectionTable(name = "stone_ability_able", joinColumns = @JoinColumn(name = "stone_id"))
    @MapKeyEnumerated(EnumType.STRING)
    private Map<AbilityType, Boolean> abilityAble;

    private String signText;

    @Builder
    public Stone (Member member, Long speciesId, String stoneName, Long closeness, Map<AbilityType, Boolean> abilityAble, String signText) {
        this.member = member;
        this.speciesId = speciesId;
        this.stoneName = stoneName;
        this.closeness = closeness;
        this.abilityAble = abilityAble;
        this.signText = signText;
    }

    //엔티티가 영속성 컨텍스트에 저장되기 전에 호출
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.modifiedAt = LocalDateTime.now();
    }

    //엔티티가 영속성 컨텍스트에 업데이트되기 전에 호출
    @PreUpdate
    protected void onUpdate() {
        this.modifiedAt = LocalDateTime.now();
    }

    public void update(Member member, Long speciesId, String stoneName, Long closeness, Map<AbilityType, Boolean> abilityAble, String signText) {
        this.member = member;
        this.speciesId = speciesId;
        this.stoneName = stoneName;
        this.closeness = closeness;
        this.abilityAble = abilityAble;
        this.signText = signText;
    }

    public Long increaseCloseness(Long increasingAmount) {
        this.closeness += increasingAmount;
        return closeness;
    }

    public void updateStoneName(String newStoneName) {
        this.stoneName = newStoneName;
    }

    public void updateSignText(String newSignText) {
        this.signText = newSignText;
    }

    public void updateAbilityAble(AbilityType abilityType) {
        if (abilityAble.get(abilityType)) {
            throw new CustomException(ErrorCode.ABILITY_ALREADY_ACTIVATED);
        }
        abilityAble.put(abilityType, true);
    }
}
