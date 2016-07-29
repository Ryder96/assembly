// TaskManagerC.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <string>
#include <stdlib.h>
#include <iostream>
struct Record 
{
	char * name = new char[8];
	int id;
	int priority;
	int cycles;
	Record *next;
};

Record * addNewRecord(int id)
{
	Record * new_record = new Record;
	std::cout << "Inserisci nome [max 8] : ";
	std::cin >> new_record->name;
	std::cout << "Inserisci priorita: ";
	std::cin >> new_record->priority;
	std::cout << "Inserisci cicli: ";
	std::cin >> new_record->cycles;
	new_record->id = id;
	new_record->next = NULL;
	return new_record;
}


int main()
{
	int id_glb = 0;
	int exit; 
	Record *head = NULL;
	Record *last = NULL;
	char * welcome_string = "Task Manager\n1) Insert a new record\n2)\nLa tua scelta: ";
	std::cout << welcome_string;
	std::cin >> exit;
	while (true && exit != 7)
	{
		if (exit == 1)
		{
			if(head == NULL)
			{
				head = addNewRecord(id_glb);
				last = head;
			}
			else 
			{	
				last->next = addNewRecord(id_glb);
				last = last->next;
			}
			++id_glb;
		}

		if (exit == 2)
		{
			
		}

		if (exit == 4)
		{
			int id_choosen;
			std::cout << "Inserire ID record da eliminare: ";
			std::cin >> id_choosen;
			Record * tmp = head;
			Record * prev = head;
			bool found = false;
			while (head != NULL && !found)
			{
				if (head->id == id_choosen)
				{
					found = !found;
					prev->next = head->next;
				}
				prev = head;
				head = head->next;
				
			}
			head = tmp;
		}
		Record * tmp_head = head;
		if (head == NULL)
		{
			std::cout << "No record inside\n";
		}
		else
		{
			std::printf("Nome\tID\tPriorita\tCicli\n");
			while (tmp_head != NULL)
			{
				std::printf("%s\t%d\t%d\t\t%d\n", tmp_head->name, tmp_head->id, tmp_head->priority, tmp_head->cycles);
				tmp_head = tmp_head->next;
			}
		}
		std::cout << welcome_string;
		std::cin >> exit;

	}

    return 0;
}

