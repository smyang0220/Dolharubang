package com.dolharubang.domain.entity;

import com.dolharubang.type.AbilityType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Getter
public class Species {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long speciesId;

    private String speciesName;

    private String characteristic;

    private AbilityType baseAbility;

    @Builder
    public Species(Long speciesId, String speciesName, String characteristic, String baseAbility) {
        this.speciesId = speciesId;
        this.speciesName = speciesName;
        this.characteristic = characteristic;
        this.baseAbility = AbilityType.valueOf(baseAbility);
    }
}
