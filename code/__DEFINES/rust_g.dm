// rust_g.dm - DM API for rust_g extension library
#define RUST_G "rust_g"

#define RUSTG_JOB_NO_RESULTS_YET "NO RESULTS YET"
#define RUSTG_JOB_NO_SUCH_JOB "NO SUCH JOB"
#define RUSTG_JOB_ERROR "JOB PANICKED"

#define rustg_dmi_strip_metadata(fname) LIBCALL(RUST_G, "dmi_strip_metadata")(fname)
#define rustg_dmi_create_png(fname,width,height,data) LIBCALL(RUST_G, "dmi_create_png")(fname,width,height,data)

#define rustg_git_revparse(rev) LIBCALL(RUST_G, "rg_git_revparse")(rev)
#define rustg_git_commit_date(rev) LIBCALL(RUST_G, "rg_git_commit_date")(rev)

#define rustg_log_write(fname, text, format) LIBCALL(RUST_G, "log_write")(fname, text, format)
/proc/rustg_log_close_all() return LIBCALL(RUST_G, "log_close_all")()

// RUST-G defines & procs for HTTP component
#define RUSTG_HTTP_METHOD_GET "get"
#define RUSTG_HTTP_METHOD_POST "post"
#define RUSTG_HTTP_METHOD_PUT "put"
#define RUSTG_HTTP_METHOD_DELETE "delete"
#define RUSTG_HTTP_METHOD_PATCH "patch"
#define RUSTG_HTTP_METHOD_HEAD "head"

#define rustg_http_request_blocking(method, url, body, headers) LIBCALL(RUST_G, "http_request_blocking")(method, url, body, headers)
#define rustg_http_request_async(method, url, body, headers) LIBCALL(RUST_G, "http_request_async")(method, url, body, headers)
#define rustg_http_check_request(req_id) LIBCALL(RUST_G, "http_check_request")(req_id)