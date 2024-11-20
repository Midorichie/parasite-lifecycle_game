import pygame
import random
import json
from dataclasses import dataclass
from typing import List, Tuple, Dict
from abc import ABC, abstractmethod
import requests
from datetime import datetime
import asyncio
from web3 import Web3
import cv2
import numpy as np

# Initialize Pygame and mixer for sound effects
pygame.init()
pygame.mixer.init()

# Enhanced Game Constants
WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 768
FPS = 60

# Colors
COLORS = {
    'WHITE': (255, 255, 255),
    'BLACK': (0, 0, 0),
    'BLUE': (0, 0, 255),
    'GREEN': (0, 255, 0),
    'RED': (255, 0, 0),
    'PURPLE': (128, 0, 128),
    'ORANGE': (255, 165, 0)
}

# Stacks Blockchain Configuration
STACKS_CONFIG = {
    'network': 'testnet',
    'contract_address': 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG',
    'contract_name': 'parasite-game',
    'function_name': 'award-tokens'
}

class ParasiteStageSprite(pygame.sprite.Sprite):
    def __init__(self, image_path: str, position: Tuple[int, int]):
        super().__init__()
        self.image = pygame.image.load(image_path)
        self.image = pygame.transform.scale(self.image, (100, 100))
        self.rect = self.image.get_rect()
        self.rect.center = position
        self.original_pos = position
        self.animation_state = 0

    def animate(self):
        # Simple floating animation
        self.rect.center = (
            self.original_pos[0],
            self.original_pos[1] + math.sin(self.animation_state) * 10
        )
        self.animation_state += 0.1

@dataclass
class ParasiteStage:
    name: str
    description: str
    duration: int
    required_conditions: List[str]
    next_stages: List[str]
    points: int
    sprite: str
    quiz_questions: List[Dict]

class Parasite(ABC):
    @abstractmethod
    def get_lifecycle(self) -> Dict:
        pass

    @abstractmethod
    def get_difficulty(self) -> int:
        pass

class Plasmodium(Parasite):
    def get_lifecycle(self):
        return {
            "sporozoite": ParasiteStage(
                name="Sporozoite",
                description="Infectious form injected by mosquito into human bloodstream",
                duration=48,
                required_conditions=["mosquito_bite"],
                next_stages=["liver_stage"],
                points=10,
                sprite="assets/sporozoite.png",
                quiz_questions=[
                    {
                        "question": "How do sporozoites enter the human body?",
                        "options": ["Mosquito bite", "Food", "Water", "Air"],
                        "correct": 0
                    }
                ]
            ),
            # Add other stages...
        }

    def get_difficulty(self):
        return 1

class Tapeworm(Parasite):
    def get_lifecycle(self):
        return {
            "egg": ParasiteStage(
                name="Egg",
                description="Tapeworm egg released in feces",
                duration=30,
                required_conditions=["contaminated_environment"],
                next_stages=["larva"],
                points=15,
                sprite="assets/tapeworm_egg.png",
                quiz_questions=[
                    {
                        "question": "Where are tapeworm eggs commonly found?",
                        "options": ["Contaminated soil", "Clean water", "Air", "Sterilized food"],
                        "correct": 0
                    }
                ]
            ),
            # Add other stages...
        }

    def get_difficulty(self):
        return 2

class BlockchainManager:
    def __init__(self):
        self.contract_address = STACKS_CONFIG['contract_address']
        self.contract_name = STACKS_CONFIG['contract_name']
        
    async def award_tokens(self, wallet_address: str, amount: int):
        try:
            # Simulate blockchain transaction
            # In production, this would interact with actual Stacks blockchain
            payload = {
                'contract_address': self.contract_address,
                'contract_name': self.contract_name,
                'function_name': STACKS_CONFIG['function_name'],
                'parameters': [
                    {'type': 'principal', 'value': wallet_address},
                    {'type': 'uint', 'value': str(amount)}
                ]
            }
            # Simulated successful transaction
            return {'txid': f'0x{random.getrandbits(256):064x}'}
        except Exception as e:
            print(f"Failed to award tokens: {e}")
            return None

class Achievement:
    def __init__(self, name: str, description: str, reward: int):
        self.name = name
        self.description = description
        self.reward = reward
        self.achieved = False

class GameState:
    def __init__(self):
        self.screen = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
        pygame.display.set_caption("Advanced Parasite Life Cycle Educational Game")
        self.clock = pygame.time.Clock()
        self.sprites = pygame.sprite.Group()
        self.blockchain_manager = BlockchainManager()
        self.running = True
        self.current_parasite = None
        self.parasites = {
            "plasmodium": Plasmodium(),
            "tapeworm": Tapeworm()
        }
        self.achievements = [
            Achievement("Lifecycle Master", "Complete all stages of a parasite lifecycle", 100),
            Achievement("Quick Learner", "Answer 5 quiz questions correctly in a row", 50)
        ]
        self.load_fonts()
        self.load_sounds()
        self.initialize_ui()
        
    def load_fonts(self):
        self.fonts = {
            'large': pygame.font.Font(None, 48),
            'medium': pygame.font.Font(None, 36),
            'small': pygame.font.Font(None, 24)
        }
        
    def load_sounds(self):
        self.sounds = {
            'success': pygame.mixer.Sound('assets/success.wav'),
            'failure': pygame.mixer.Sound('assets/failure.wav'),
            'achievement': pygame.mixer.Sound('assets/achievement.wav')
        }

    def initialize_ui(self):
        self.ui_elements = {
            'main_menu': UIPanel(self.screen, "Select Parasite", self.fonts['large']),
            'game': UIPanel(self.screen, "Parasite Lifecycle", self.fonts['large']),
            'quiz': UIPanel(self.screen, "Knowledge Check", self.fonts['large'])
        }

    async def handle_blockchain_reward(self, points):
        if self.player_wallet["address"]:
            tx = await self.blockchain_manager.award_tokens(
                self.player_wallet["address"],
                points
            )
            if tx:
                self.show_notification(f"Awarded {points} tokens! TX: {tx['txid'][:10]}...")

    def show_notification(self, message):
        notification = self.fonts['medium'].render(message, True, COLORS['GREEN'])
        self.screen.blit(notification, (WINDOW_WIDTH//2 - notification.get_width()//2, 20))
        pygame.display.update()
        pygame.time.wait(2000)

    def check_achievements(self):
        for achievement in self.achievements:
            if not achievement.achieved:
                # Check achievement conditions
                if achievement.name == "Lifecycle Master" and self.parasite.score >= 1000:
                    achievement.achieved = True
                    self.sounds['achievement'].play()
                    asyncio.create_task(self.handle_blockchain_reward(achievement.reward))

    def run_quiz(self):
        current_stage = self.parasite.stages[self.parasite.current_stage]
        if current_stage.quiz_questions:
            question = random.choice(current_stage.quiz_questions)
            correct = self.show_quiz_screen(question)
            if correct:
                self.parasite.score += 50
                self.sounds['success'].play()
            else:
                self.sounds['failure'].play()

    def show_quiz_screen(self, question):
        # Quiz UI implementation
        pass

    def update(self):
        self.sprites.update()
        self.check_achievements()
        if random.random() < 0.05:  # 5% chance per frame
            self.run_quiz()

    def draw(self):
        self.screen.fill(COLORS['WHITE'])
        self.sprites.draw(self.screen)
        self.ui_elements[self.current_screen].draw()
        pygame.display.flip()

    def run(self):
        while self.running:
            self.handle_events()
            self.update()
            self.draw()
            self.clock.tick(FPS)

class UIPanel:
    def __init__(self, screen, title, font):
        self.screen = screen
        self.title = title
        self.font = font
        self.elements = []

    def add_element(self, element):
        self.elements.append(element)

    def draw(self):
        title_surface = self.font.render(self.title, True, COLORS['BLACK'])
        self.screen.blit(title_surface, (WINDOW_WIDTH//2 - title_surface.get_width()//2, 10))
        for element in self.elements:
            element.draw(self.screen)

def main():
    game = GameState()
    asyncio.run(game.run())
    pygame.quit()

if __name__ == "__main__":
    main()