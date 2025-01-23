package com.dolharubang.domain.entity;

import com.dolharubang.mongo.enumTypes.ItemType;
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

    @ElementCollection
    @CollectionTable(name = "stone_custom", joinColumns = @JoinColumn(name = "stone_id"))
    @MapKeyEnumerated(EnumType.STRING)
    private Map<ItemType, String> custom;

    @Builder
    public Stone (Member member, Long speciesId, String stoneName, Long closeness, Map<AbilityType, Boolean> abilityAble, String signText, Map<ItemType, String> custom) {
        this.member = member;
        this.speciesId = speciesId;
        this.stoneName = stoneName;
        this.closeness = closeness;
        this.abilityAble = abilityAble;
        this.signText = signText;
        this.custom = custom;
    }

    public void update(Member member, Long speciesId, String stoneName, Long closeness, Map<AbilityType, Boolean> abilityAble, String signText, Map<ItemType, String> custom) {
        this.member = member;
        this.speciesId = speciesId;
        this.stoneName = stoneName;
        this.closeness = closeness;
        this.abilityAble = abilityAble;
        this.signText = signText;
        this.custom = custom;
    }
}
