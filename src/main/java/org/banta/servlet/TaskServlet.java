package org.banta.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.banta.model.Task;
import org.banta.service.TaskService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/task")
public class TaskServlet extends HttpServlet {

    @Inject
    private TaskService taskService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        // Handle root path
        if (pathInfo == null || pathInfo.equals("/")) {
            listTasks(request, response);
            return;
        }

        // Handle other actions
        if (action == null) {
            action = "list";
        }
        try {
            switch (action) {
                case "list":
                    listTasks(request, response);
                    break;
                case "view":
                    viewtask(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteTask(request, response);
                    break;
                default:
                    listTasks(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error processing POST request: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createTask(request, response);
                    break;
                case "edit":
                    updateTask(request, response);
                    break;
                default:
                    listTasks(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error processing POST request: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }
    private void listTasks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Task> tasks = taskService.getAllTasks();
            System.out.println("Number of tasks found: " + tasks.size());  // Log the number of tasks retrieved
            request.setAttribute("tasks", tasks);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            log("Error retrieving task list: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Failed to retrieve task list. Please try again later.");
            request.setAttribute("tasks", List.of());  // Passing an empty list to prevent null pointer exceptions
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }


    private void viewtask(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "task ID is required.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            Task task = taskService.getTaskById(id);
            if (task != null) {
                request.setAttribute("task", task);
                request.getRequestDispatcher("/views/task/view.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID format.");
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/task/create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "task ID is required.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            Task task = taskService.getTaskById(id);
            if (task != null) {
                request.setAttribute("task", task);
                request.getRequestDispatcher("/views/task/edit.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "task not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid task ID format.");
        }
    }
    private void createTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        LocalDate creationDate = LocalDate.parse(request.getParameter("creationDate"));
        LocalDate deadline = LocalDate.parse(request.getParameter("deadline"));

        Task newtask = new Task(title, description, creationDate, deadline);
        taskService.createTask(newtask);
        response.sendRedirect("task?action=list");
    }
    private void updateTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "task ID is required.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            LocalDate creationDate = LocalDate.parse(request.getParameter("creationDate"));
            LocalDate deadline = LocalDate.parse(request.getParameter("deadline"));


            Task task = taskService.getTaskById(id);
            if (task != null) {
                task.setTitle(title);
                task.setDescription(description);
                task.setDeadline(deadline);
                taskService.updateTask(task);
                response.sendRedirect("task?action=list");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "task not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid task ID format.");
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "task ID is required.");
            return;
        }
        try {
            Long id = Long.parseLong(idParam);
            taskService.deleteTask(id);
            response.sendRedirect("task?action=list");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid task ID format.");
        }
    }
}
