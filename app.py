import tkinter as tk
from tkinter import messagebox, ttk
import mysql.connector

# ------------------ DATABASE CONNECTION ------------------
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="gymDBMS"
)

cursor = db.cursor()

# ------------------ MAIN WINDOW ------------------
root = tk.Tk()
root.title("Gym Management System")
root.geometry("400x600")

# ------------------ ADD MEMBER ------------------
def add_member():
    mid = entry_id.get()
    name = entry_name.get()
    phone = entry_phone.get()
    membership = membership_var.get()

    try:
        query = "INSERT INTO Members (MemberID, Name, Phone, MembershipType) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (mid, name, phone, membership))
        db.commit()
        messagebox.showinfo("Success", "Member Added")
    except Exception as e:
        messagebox.showerror("Error", str(e))

# ------------------ UPDATE MEMBER ------------------
def update_member():
    mid = entry_id.get()
    name = entry_name.get()
    phone = entry_phone.get()
    membership = membership_var.get()

    try:
        query = "UPDATE Members SET Name=%s, Phone=%s, MembershipType=%s WHERE MemberID=%s"
        cursor.execute(query, (name, phone, membership, mid))
        db.commit()
        messagebox.showinfo("Success", "Member Updated")
    except Exception as e:
        messagebox.showerror("Error", str(e))

# ------------------ DELETE MEMBER ------------------
def delete_member():
    mid = entry_id.get()

    try:
        query = "DELETE FROM Members WHERE MemberID=%s"
        cursor.execute(query, (mid,))
        db.commit()
        messagebox.showinfo("Success", "Member Deleted")
    except Exception as e:
        messagebox.showerror("Error", str(e))

# ------------------ SEARCH MEMBER ------------------
def search_member():
    mid = entry_id.get()

    try:
        query = "SELECT * FROM Members WHERE MemberID=%s"
        cursor.execute(query, (mid,))
        row = cursor.fetchone()

        if row:
            entry_name.delete(0, tk.END)
            entry_name.insert(0, row[1])

            entry_phone.delete(0, tk.END)
            entry_phone.insert(0, row[2])

            membership_var.set(row[3])
        else:
            messagebox.showinfo("Not Found", "Member not found")

    except Exception as e:
        messagebox.showerror("Error", str(e))

# ------------------ VIEW MEMBERS ------------------
def view_members():
    cursor.execute("SELECT * FROM Members")
    rows = cursor.fetchall()

    view_window = tk.Toplevel(root)
    view_window.title("Members List")

    for i, row in enumerate(rows):
        for j, val in enumerate(row):
            tk.Label(view_window, text=val, borderwidth=1, relief="solid", width=15).grid(row=i, column=j)

# ------------------ ADD PAYMENT ------------------
def add_payment():
    pid = entry_pid.get()
    mid = entry_mid.get()
    amount = entry_amount.get()

    try:
        query = "INSERT INTO Payments (PaymentID, MemberID, Amount) VALUES (%s, %s, %s)"
        cursor.execute(query, (pid, mid, amount))
        db.commit()
        messagebox.showinfo("Success", "Payment Added")
    except Exception as e:
        messagebox.showerror("Error", str(e))

# ------------------ UI ------------------
tk.Label(root, text="Gym Management System", font=("Arial", 16)).pack(pady=10)

# Member Inputs
entry_id = tk.Entry(root)
entry_id.pack()
entry_id.insert(0, "Member ID")

entry_name = tk.Entry(root)
entry_name.pack()
entry_name.insert(0, "Name")

entry_phone = tk.Entry(root)
entry_phone.pack()
entry_phone.insert(0, "Phone")

membership_var = tk.StringVar()
membership_dropdown = ttk.Combobox(root, textvariable=membership_var)
membership_dropdown['values'] = ("Monthly", "Yearly")
membership_dropdown.pack()
membership_dropdown.set("Monthly")

# Buttons
tk.Button(root, text="Add Member", command=add_member).pack(pady=3)
tk.Button(root, text="Update Member", command=update_member).pack(pady=3)
tk.Button(root, text="Delete Member", command=delete_member).pack(pady=3)
tk.Button(root, text="Search Member", command=search_member).pack(pady=3)
tk.Button(root, text="View Members", command=view_members).pack(pady=3)

# Payment Section
tk.Label(root, text="Payment Section", font=("Arial", 14)).pack(pady=10)

entry_pid = tk.Entry(root)
entry_pid.pack()
entry_pid.insert(0, "Payment ID")

entry_mid = tk.Entry(root)
entry_mid.pack()
entry_mid.insert(0, "Member ID")

entry_amount = tk.Entry(root)
entry_amount.pack()
entry_amount.insert(0, "Amount")

tk.Button(root, text="Add Payment", command=add_payment).pack(pady=5)

# RUN APP
root.mainloop()