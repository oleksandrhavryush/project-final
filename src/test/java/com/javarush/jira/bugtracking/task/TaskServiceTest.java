package com.javarush.jira.bugtracking.task;

import com.javarush.jira.bugtracking.Handlers;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.BDDMockito;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyLong;

@ExtendWith(MockitoExtension.class)
public class TaskServiceTest {

    @Mock
    private Handlers.ActivityHandler activityHandler;

    @Mock
    private ActivityRepository activityRepository;

    @InjectMocks
    private TaskService taskService;

    @Test
    @DisplayName("testing working time method functionality")
    public void givenTasks_whenWorkingTimeMethodExecute_thenReturnCorrectResult() {
        //given
        Task task = new Task();
        task.setId(1L);

        BDDMockito.given(activityHandler.getRepository())
                .willReturn(activityRepository);
        BDDMockito.given(activityRepository.findAllByTaskIdOrderByUpdatedDesc(anyLong()))
                .willReturn(TaskTestData.getUpdatedActivityCorrect());
        //when
        Long time = taskService.calculateTimeInWork(task);
        //then
        assertThat(time).isEqualTo(60);
    }

    @Test
    @DisplayName("testing working time method incorrect data functionality")
    public void givenTasksAndIncorrectListActivities_whenWorkingTimeMethodExecute_thenThrowException() {
        //given
        Task task = new Task();
        task.setId(1L);

        BDDMockito.given(activityHandler.getRepository())
                .willReturn(activityRepository);
        BDDMockito.given(activityRepository.findAllByTaskIdOrderByUpdatedDesc(anyLong()))
                .willReturn(TaskTestData.getUpdatedActivityIncorrect());
        //when
        //then
        assertThrows(IllegalStateException.class, () -> taskService.calculateTimeInWork(task));
    }


    @Test
    @DisplayName("testing testing time method functionality")
    public void givenTasks_whenTestingTimeMethodExecute_thenReturnCorrectResult() {
        //given
        Task task = new Task();
        task.setId(1L);

        BDDMockito.given(activityHandler.getRepository())
                .willReturn(activityRepository);
        BDDMockito.given(activityRepository.findAllByTaskIdOrderByUpdatedDesc(anyLong()))
                .willReturn(TaskTestData.getUpdatedActivityCorrect());
        //when
        Long time = taskService.calculateTimeInTesting(task);
        //then
        assertThat(time).isEqualTo(60);
    }

    @Test
    @DisplayName("testing testing time method incorrect data functionality")
    public void givenTasksAndIncorrectListActivities_whenTestingTimeMethodExecute_thenThrowException() {
        //given
        Task task = new Task();
        task.setId(1L);

        BDDMockito.given(activityHandler.getRepository())
                .willReturn(activityRepository);
        BDDMockito.given(activityRepository.findAllByTaskIdOrderByUpdatedDesc(anyLong()))
                .willReturn(TaskTestData.getUpdatedActivityIncorrect());
        //when
        //then
        assertThrows(IllegalStateException.class, () -> taskService.calculateTimeInTesting(task));
    }

    @Test
    @DisplayName("testing working time method with empty activity list")
    public void givenTasksWithEmptyActivityList_whenWorkingTimeMethodExecute_thenThrowException() {
        //given
        Task task = new Task();
        task.setId(1L);

        BDDMockito.given(activityHandler.getRepository())
                .willReturn(activityRepository);
        BDDMockito.given(activityRepository.findAllByTaskIdOrderByUpdatedDesc(anyLong()))
                .willReturn(Collections.emptyList());
        //when
        //then
        assertThrows(IllegalStateException.class, () -> taskService.calculateTimeInWork(task));
    }

}