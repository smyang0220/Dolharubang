package com.dolharubang.domain.dto.response;

import com.dolharubang.domain.entity.MemberItem;
import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Builder
@Getter
@Setter
@ToString
public class MemberItemResDto {
    private Long memberItemId;
    private String itemId;
    private boolean whetherHasItem;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

    public static MemberItemResDto fromEntity(MemberItem memberItem) {
        return MemberItemResDto.builder()
            .memberItemId(memberItem.getMemberItemId())
            .itemId(memberItem.getItemId())
            .whetherHasItem(memberItem.isWhetherHasItem())
            .createdAt(memberItem.getCreatedAt())
            .modifiedAt(memberItem.getModifiedAt())
            .build();
    }
}
