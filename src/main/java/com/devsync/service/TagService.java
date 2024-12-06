package com.devsync.service;


import com.devsync.domain.entity.Tag;
import com.devsync.domain.entity.Task;
import com.devsync.repository.Implementations.TagRepository;
import com.devsync.repository.Implementations.TaskRepository;
import com.devsync.util.DateUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class TagService {


    private TagRepository tagRepository;

    public TagService(TagRepository tagRepository) {
        this.tagRepository = new TagRepository();
    }


    public List<Tag> getTags() {
        return tagRepository.findAll();
    }

    public Tag getTagById(Long id) {
        return tagRepository.findById(id);
    }









}
