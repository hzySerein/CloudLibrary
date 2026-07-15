package org.cloudlibrary.controller;

import org.cloudlibrary.constant.AppConstants;
import org.cloudlibrary.entity.Book;
import org.cloudlibrary.service.BookService;
import org.cloudlibrary.util.PageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/admin/book")
public class AdminBookController {

    @Autowired
    private BookService bookService;

    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            Model model) {
        int offset = (page - 1) * size;
        List<Book> books;
        int totalCount;
        if (keyword != null && !keyword.trim().isEmpty()) {
            books = bookService.searchBooks(keyword, offset, size);
            totalCount = bookService.countSearchBooks(keyword);
        } else {
            totalCount = bookService.countTotalBook();
            books = bookService.getBooksByPage(offset, size);
        }
        model.addAttribute("pageUtil", new PageUtil<>(page, size, totalCount, books));
        model.addAttribute("keyword", keyword);
        return "admin/book/list";
    }

    @GetMapping("/toAdd")
    public String toAdd() {
        return "admin/book/add";
    }

    @PostMapping("/add")
    public String add(Book book, @RequestParam(value = "coverFile", required = false) MultipartFile coverFile,
                      HttpServletRequest request, Model model) {
        try {
            String uploadDir = request.getSession().getServletContext().getRealPath(AppConstants.UPLOAD_DIR_BOOKS);
            bookService.addBookWithCover(book, coverFile, uploadDir);
            model.addAttribute("message", coverFile != null && !coverFile.isEmpty()
                    ? "图书添加成功，封面上传成功" : "图书添加成功");
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("book", book);
            return "admin/book/add";
        } catch (Exception e) {
            model.addAttribute("error", "图书添加失败，请稍后重试");
            return "admin/book/add";
        }
        return "redirect:/admin/book/list";
    }

    @GetMapping("/toEdit/{id}")
    public String toEdit(@PathVariable Integer id, Model model) {
        model.addAttribute("book", bookService.getBookById(id));
        return "admin/book/edit";
    }

    @PostMapping("/edit")
    public String edit(Book book, Model model) {
        try {
            bookService.updateBookPreservingCover(book);
            model.addAttribute("message", "图书编辑成功");
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("book", book);
            return "admin/book/edit";
        } catch (Exception e) {
            model.addAttribute("error", "编辑图书失败，请稍后重试");
            return "admin/book/edit";
        }
        return "redirect:/admin/book/list";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, HttpServletRequest request) {
        try {
            String realPath = request.getSession().getServletContext().getRealPath("/");
            bookService.deleteBookWithCover(id, realPath);
        } catch (IllegalStateException e) {
            return "redirect:/admin/book/list?error=has_borrows";
        }
        return "redirect:/admin/book/list";
    }

    @PostMapping("/disable/{id}")
    public String disable(@PathVariable Integer id) {
        bookService.disableBook(id);
        return "redirect:/admin/book/list";
    }

    @PostMapping("/enable/{id}")
    public String enable(@PathVariable Integer id) {
        bookService.enableBook(id);
        return "redirect:/admin/book/list";
    }

    @PostMapping("/uploadCover/{id}")
    @ResponseBody
    public String uploadCover(@PathVariable Integer id,
                              @RequestParam("coverFile") MultipartFile coverFile,
                              HttpServletRequest request) {
        try {
            String uploadDir = request.getSession().getServletContext().getRealPath(AppConstants.UPLOAD_DIR_BOOKS);
            bookService.uploadCover(id, coverFile, uploadDir);
            return "封面上传成功";
        } catch (IllegalArgumentException e) {
            return e.getMessage();
        } catch (Exception e) {
            return "封面上传失败";
        }
    }

    @GetMapping(value = "/detail/{id}", produces = "application/json")
    @ResponseBody
    public Book getBookDetail(@PathVariable Integer id) {
        Book book = bookService.getBookById(id);
        if (book != null) {
            return book;
        }
        Book errorBook = new Book();
        errorBook.setId(-1);
        errorBook.setName("未找到图书");
        return errorBook;
    }
}
