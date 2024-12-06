package com.devsync.repository.Interfaces;

import com.devsync.domain.entity.Tag;

import java.util.List;

public interface TagsRepositoryInterface extends MainCrudRepository<Tag, Integer> {
    List<Tag> findByName(String name);
    List<Tag> findByCategory(String category);
}
