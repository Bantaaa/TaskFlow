package com.devsync.repository.Interfaces;

import java.util.List;

public interface MainCrudRepository<T, ID> {

    T create(T entity);

    List<T> findAll();
    T findById(ID id);

    T update(T entity);

    void deleteById(ID id);
    void delete(T entity);

//    List<T> updateAll(List<T> entities);
//    List<T> createAll(List<T> entities);
//    void deleteAll(List<T> entities);
}
